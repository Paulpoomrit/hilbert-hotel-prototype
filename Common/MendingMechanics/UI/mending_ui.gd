extends Control


@onready var mending_area: GridContainer = $CenterContainer/HBoxContainer/MendingArea
@onready var inventory: GridContainer = $CenterContainer/HBoxContainer/Inventory


const HAND_OPEN = preload("uid://b88plxri55slp")
const HAND_CLOSED = preload("uid://bgrreho233ug0")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(HAND_OPEN, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_DRAG)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
