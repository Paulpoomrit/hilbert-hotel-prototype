extends Node


signal on_block_drop(block: Block)

signal on_change_gravity_type(new_val: Variant, negated: bool, target: Object)
signal on_change_speed_type(new_val: Variant, negated: bool, target: Object)
signal on_change_time_type(new_val: Variant, negated: bool, target: Object)
signal on_change_colour_type(new_val: Variant, negated: bool, target: Object)

var mouse_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# Cancle drag if the player moves
	if Input.is_action_pressed("left") or \
		Input.is_action_pressed("right") or \
		Input.is_action_pressed("jump"):
			get_viewport().gui_cancel_drag()


func check_if_mouse_in_viewport(mouse_pos: Vector2) -> bool:
	if mouse_pos <= get_viewport().get_visible_rect().size and \
		mouse_pos >= Vector2(0,0):
		print(mouse_pos)
		return true
	return false
