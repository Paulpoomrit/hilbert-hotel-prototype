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

	var sentences = grab_all_possible_sentences_from_rows_and_columns(block)
	if not sentences:
		return
	var valid_sentence_to_implement = find_first_valid_sentence(sentences)
	
	if valid_sentence_to_implement:
		Parser.implement(valid_sentence_to_implement)
		_implemented_sentences[find_first_occurence(valid_sentence_to_implement[0])] = valid_sentence_to_implement
	
		handle_block_effects(valid_sentence_to_implement, true)
	
	revert_non_active_rules_to_default()


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
	# print("Implemented sentences: %s" % _implemented_sentences)
	var sentences_to_revert = _implemented_sentences.duplicate_deep()
	for key in sentences_to_revert:
		var first_block = _grid_array[key]
		var sentences = grab_all_possible_sentences_from_rows_and_columns(first_block)
		if not sentences:
			return
		var valid_sentence = find_first_valid_sentence(sentences)
		if valid_sentence == sentences_to_revert[key]:
			# print("Not reverting: %s" % valid_sentence)
			sentences_to_revert.erase(key)

	for sentence in sentences_to_revert:
		print("Reverting: %s" % sentences_to_revert[sentence])
		_implemented_sentences.erase(sentence)
		Parser.reverse(sentences_to_revert[sentence])
		handle_block_effects(sentences_to_revert[sentence], false)


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


## Returns the index of the first occurence of the block type in the mending area
func find_first_occurence(block_type: String) -> Variant:
	for i in range(_grid_array.size()):
		if _grid_array[i].get_block_type() == block_type:
			return i
	return null


## Disable or enable each individual blocks 
## (serves as a callback to let each block handle their own effects)
func handle_block_effects(sentence: PackedStringArray, enable: bool = true) -> void:
	for block_string: String in sentence:
		var block_to_enable: int = find_first_occurence(block_string)
		
		if enable:
			_grid_array[block_to_enable].enable_block()
		else:
			_grid_array[block_to_enable].disable_block()
