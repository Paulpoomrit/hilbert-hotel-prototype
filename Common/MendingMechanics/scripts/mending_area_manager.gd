extends GridContainer


@export var block_hover_scale = Vector2(1.2, 1.2)


var _grid_array: Array[Block]
var _implemented_sentences: Dictionary[int, PackedStringArray]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grid_array()
	MendingSignalHub.on_block_drop.connect(HandleBlockDropped)


func populate_grid_array() -> void:
	
	for block: Block in get_children():
		block.set_block_hover_scale(block_hover_scale)
		_grid_array.append(block)
	
	print(_grid_array)


func HandleBlockDropped(block: Block) -> void:

	var sentences = grab_all_possible_sentences_from_rows_and_columns(block)
	if not sentences:
		return
	var valid_sentence_to_implement = find_first_valid_sentence(sentences)
	
	if valid_sentence_to_implement:
		Parser.implement(valid_sentence_to_implement)
		_implemented_sentences[_grid_array.find(valid_sentence_to_implement[0])] = valid_sentence_to_implement


func find_first_valid_sentence(sentences: Array[PackedStringArray]) -> Variant:
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
	for key in _implemented_sentences:
		var first_block = _grid_array[key]


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
