extends GridContainer


var _grid_array: Array[Block]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grid_array()
	MendingSignalHub.on_block_drop.connect(HandleBlockDropped)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func populate_grid_array() -> void:
	
	for block in get_children():
		_grid_array.append(block)
	
	print(_grid_array)


func HandleBlockDropped(block: Block) -> void:
	var block_index = _grid_array.find(block)
	if block_index == -1:
		return
		
	var row = block_index / columns # starting from 0
	var row_start_index = row * columns
	
	var row_string: String
	
	# Loop over all the elements in that row
	for i in range(row_start_index, row_start_index + columns):
		row_string += _grid_array[i]._block_type + " "
	
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
		print(sentence)
		sentences.append(sentence.split(" ", false))
	
	print(sentences)
	
	
	
	
	# Try parsing the first k words
	#for k in range(3, sentence.size() + 1):
		#Parser.is_valid(sentence.slice(0,k)) 
