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
		
	var row = block_index / 4 # starting from 0
	var row_start_index = row * columns
	
	var sentence: Array[String]
	
	# Loop over all the elements in that row
	for i in range(row_start_index, row_start_index + columns):
		sentence.append(_grid_array[i]._block_type)
	
	if sentence.size() < 3:
		return
	
	# Try parsing the first k words
	for k in range(2, sentence.size() + 1):
		Parser.is_valid(sentence.slice(0,k))
