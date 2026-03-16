extends GridContainer


@export var block_hover_scale = Vector2(1.2, 1.2)


var _grid_array: Array[Block]
var _implemented_sentences: Dictionary[int, PackedStringArray]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_grid_array()
	MendingSignalHub.on_block_drop.connect(HandleBlockDropped)


func update_grid_array() -> void:
	
	_grid_array.clear()
	
	for block in get_children():
		if not is_instance_of(block, Block):
			continue
		block.set_block_hover_scale(block_hover_scale)
		_grid_array.append(block)
	
	# print(_grid_array)


func HandleBlockDropped(block: Block) -> void:
	
	update_grid_array()
	revert_non_active_rules_to_default()

	var sentences = grab_all_possible_sentences_from_rows_and_columns(block)
	if not sentences:
		return
	var valid_sentence_to_implement = find_first_valid_sentence(sentences)
	
	if valid_sentence_to_implement:
		Parser.implement(valid_sentence_to_implement)
		var first_block_list = find_first_occurrence_sentence(" ".join(valid_sentence_to_implement))
		if first_block_list:
			# Update the list of all implemented rules (globally)
			if MendingSignalHub._global_implemented_rules.has(valid_sentence_to_implement):
				MendingSignalHub._global_implemented_rules[valid_sentence_to_implement] += 1
			else:
				# intialize the entry if there's none
				MendingSignalHub._global_implemented_rules[valid_sentence_to_implement] = 1
			_implemented_sentences[first_block_list[0]] = valid_sentence_to_implement
			handle_block_effects(valid_sentence_to_implement, true)


func find_first_valid_sentence(sentences: Array[PackedStringArray]) -> Variant:
	# Returns a variant of either PackedStringArray for a valid sentence or null if none exists
	for sentence in sentences:
		#print(" ".join(sentence) + "\n-------\n")
		# Try parsing the first k words
		for k in range(sentence.size() + 1, -1, -1):
			#print("First k")
			if Parser.is_valid(sentence.slice(0,k)):
				# Found valid parse!
				return sentence.slice(0,k)
			#print("Last k")
			if Parser.is_valid(sentence.slice(k, sentence.size())):
				# Found valid parse!
				return sentence.slice(k, sentence.size())
			
			# Try parsing the middle words from k to l
			for l in range(k+1, sentence.size()+1):
				#print("Middle")
				if Parser.is_valid(sentence.slice(k, l)):
					# Found valid parse!
					return sentence.slice(k, l)
	return null


func revert_non_active_rules_to_default():
	#print("Implemented sentences: %s" % _implemented_sentences)
	var sentences_to_revert = _implemented_sentences.duplicate_deep()
	for key in sentences_to_revert.keys():
		#print(key)
		var first_block = _grid_array[key]
		var sentences = grab_all_possible_sentences_from_rows_and_columns(first_block)
		if sentences:
			var valid_sentence = find_first_valid_sentence(sentences)
			if valid_sentence == sentences_to_revert[key]:
				print("Not reverting: %s" % valid_sentence)
				sentences_to_revert.erase(key)

	for sentence in sentences_to_revert:
		#print(sentence)
		handle_block_effects(sentences_to_revert[sentence], false)
		_implemented_sentences.erase(sentence)
		# Skip reversing if there is more than 1 instance of the rule being applied globally
		if MendingSignalHub._global_implemented_rules.has(sentences_to_revert[sentence]) and \
			   MendingSignalHub._global_implemented_rules[sentences_to_revert[sentence]] > 1:
			continue
		#print("Reverting: %s" % sentences_to_revert[sentence])
		
		# Update the list of all globally implemented rules
		if MendingSignalHub._global_implemented_rules.has(sentences_to_revert[sentence]):
			MendingSignalHub._global_implemented_rules[sentences_to_revert[sentence]] -= 1
		Parser.reverse(sentences_to_revert[sentence])


func grab_all_possible_sentences_from_rows_and_columns(block: Block) -> Variant:
	var block_index = _grid_array.find(block)
	if block_index == -1:
		return
		
	@warning_ignore("integer_division")
	var row = block_index / columns # starting from 0
	var row_start_index = row * columns
	
	var strings_for_processing: String = ""
	
	# 1. GRAB ALL SENTENCES IN ROW
	for i in range(row_start_index, row_start_index + columns):
		strings_for_processing += _grid_array[i]._block_type + " "
	
	# 2. GRAB ALL SENTENCES IN COLUMN
	var col = block_index - row_start_index # starting from 0
	for i in range(col, _grid_array.size(), columns):
		strings_for_processing += _grid_array[i]._block_type + " "
	
	
	# Replace all the nulls in between with _
	# which will be used later as the delimeter
	var null_regex = RegEx.create_from_string("(Null )+")
	strings_for_processing = null_regex.sub(strings_for_processing, "_ ", true)
	strings_for_processing = strings_for_processing.rstrip(" ")
	
	var temp_sentences := strings_for_processing.split("_", false)
	var sentences: Array[PackedStringArray]
	
	for sentence in temp_sentences:
		sentence = sentence.lstrip(" ")
		sentence = sentence.rstrip(" ")
		sentences.append(sentence.split(" ", false))
	
	return sentences


## Returns the index of the first occurrence of the block type in the mending area
func find_first_occurrence(block_type: String) -> Variant:
	for i in range(_grid_array.size()):
		if _grid_array[i].get_block_type() == block_type:
			return i
	return null


## Returns the list of the indices of the first occurrence of the sentence in the mending area
func find_first_occurrence_sentence(sentence: String):
	var sentence_list = sentence.split(" ")
	var word_count = sentence_list.size();
	var first_index: int
	var found_first_index: bool
	
	## Find Row
	for i in range(_grid_array.size()):
		for j in range(word_count):
			if _grid_array[i+j]._block_type != sentence_list[j]:
				break
			if j == sentence_list.size() - 1:
				first_index = i
				found_first_index = true
				#print("first_index: %s" % first_index)
				break;
		if found_first_index:
			break;
	
	if found_first_index:
		var index_list: Array[int]
		for j in range(word_count):
			index_list.append(first_index + j)
		return index_list
	
	## Find Column
	for i in range(_grid_array.size()):
		for j in range(word_count):
			if i+(j*columns) >= _grid_array.size():
				break
			if _grid_array[i+(j*columns)]._block_type != sentence_list[j]:
				break
			if j == sentence_list.size() - 1:
				first_index = i
				found_first_index = true
				#print(first_index)
				break;
		if found_first_index:
			break;
	
	if found_first_index:
		var index_list: Array[int]
		for j in range(word_count):
			index_list.append(first_index + (j * columns))
		return index_list


## Returns the list of the indices of the first occurrence of the sentence in the mending area (allow for one to be missing)
func find_first_occurrence_sentence_with_one_missing(sentence: String):
	var sentence_list = sentence.split(" ")
	var word_count = sentence_list.size();
	var first_index: int
	var found_first_index: bool
	
	## Find Row
	for i in range(_grid_array.size()):
		var missing_word_counter = 0
		for j in range(word_count):
			if i+j >= _grid_array.size():
				break
			if _grid_array[i+j]._block_type != sentence_list[j]:
				missing_word_counter += 1
			if missing_word_counter > 1:
				break
			if j == sentence_list.size() - 1:
				first_index = i
				found_first_index = true
				#print(first_index)
				break;
		if found_first_index:
			break;
	
	if found_first_index:
		var index_list: Array[int]
		for j in range(word_count):
			index_list.append(first_index + j)
		return index_list
	
	## Find Column
	for i in range(_grid_array.size()):
		var missing_word_counter = 0
		for j in range(word_count):
			if i+(j*columns) >= _grid_array.size():
				break
			if _grid_array[i+(j*columns)]._block_type != sentence_list[j]:
				missing_word_counter += 1
			if missing_word_counter > 1:
				break
			if j == sentence_list.size() - 1:
				first_index = i
				found_first_index = true
				#print(first_index)
				break;
		if found_first_index:
			break;
	
	if found_first_index:
		var index_list: Array[int]
		for j in range(word_count):
			index_list.append(first_index + (j * columns))
		return index_list


## Disable or enable each individual blocks 
## (serves as a callback to let each block handle their own effects)
func handle_block_effects(sentence: PackedStringArray, enable: bool) -> void:
	
	var index_list = find_first_occurrence_sentence_with_one_missing(" ".join(sentence))
	
	if index_list:
		#print("handle_block_effect: %s" % " ".join(index_list))
		for i in index_list:
			var block_to_enable = _grid_array[i]
			
			if not block_to_enable:
				return
			
			if enable:
				print("enable: %s" % " ".join(index_list))
				block_to_enable.enable_block()
			else:
				block_to_enable.disable_block()
		return
