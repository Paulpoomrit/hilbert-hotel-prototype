extends Control


@onready var mending_area: GridContainer = $CenterContainer/HBoxContainer/MendingArea
@onready var inventory: GridContainer = $CenterContainer/HBoxContainer/Inventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for block in mending_area.columns:
		print(block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
