extends Control


@onready var _mending_area: GridContainer = $CenterContainer/HBoxContainer/MendingArea
@onready var _inventory: CanvasLayer = $InventoryArea


const HAND_OPEN = preload("uid://b88plxri55slp")
const HAND_CLOSED = preload("uid://bgrreho233ug0")


var is_in_mending_mode: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(HAND_OPEN, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_DRAG)
	
	update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mend"):
		is_in_mending_mode = not is_in_mending_mode
		update_ui()


func update_ui() -> void:
	if (is_in_mending_mode):
		self.visible = true
		_inventory.visible = true
	else:
		self.visible = false
		_inventory.visible = false
