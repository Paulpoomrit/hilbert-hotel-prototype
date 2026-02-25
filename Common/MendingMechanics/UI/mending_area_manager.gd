extends GridContainer


var _grid_array: Array[Block]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grid_array()
	MendingSignalHub.on_block_drop.connect(HandleBlockDropped)


func populate_grid_array() -> void:
	
	for block in get_children():
		_grid_array.append(block)
	
	print(_grid_array)


func HandleBlockDropped(block: Block) -> void:
	var block_index = _grid_array.find(block)
	if block_index == -1:
		return
		
	@warning_ignore("integer_division")
	var row = block_index / columns # starting from 0
	var row_start_index = row * columns
	
	var row_string: String = ""
	
	# 1. GRAB ALL SENTENCES IN ROW
	for i in range(row_start_index, row_start_index + columns):
		row_string += _grid_array[i]._block_type + " "
	
	# 2. GRAB ALL SENTENCES IN COLUMN
	var col = block_index - row_start_index # starting from 0
	for i in range(col, _grid_array.size(), columns):
		print(i)
	
	
	# Replace all the nulls in between with _
	# which will be used later as the delimeter
	var null_regex = RegEx.create_from_string("(Null )+")
	row_string = null_regex.sub(row_string, "_ ", true)
	row_string = row_string.rstrip(" ")
	
	var temp_sentences := row_string.split("_", false)
	var sentences: Array[PackedStringArray]
	
	for sentence in temp_sentences:
		sentence = sentence.lstrip(" ")
		sentence = sentence.rstrip(" ")
		sentences.append(sentence.split(" ", false))
	
	# print(sentences)
	
	for sentence in sentences:
		#print(" ".join(sentence) + "\n-------\n")
		# Try parsing the first k words
		for k in range(sentence.size() + 1, -1, -1):
			#print("First k")
			if Parser.is_valid(sentence.slice(0,k)):
				return # TODO: Found valid parse! -> DO SOMERTHING
			#print("Last k")
			if Parser.is_valid(sentence.slice(k, sentence.size())):
				return # TODO: Found valid parse! -> DO SOMERTHING
			
			# Try parsing the middle words from k to l
			for l in range(k+1, sentence.size()+1):
				#print("Middle")
				if Parser.is_valid(sentence.slice(k, l)):
					return # TODO: Found valid parse! -> DO SOMERTHING
		
