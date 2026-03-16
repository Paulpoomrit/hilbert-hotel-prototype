extends Node


signal on_block_drop(block: Block)

signal on_change_gravity_type(new_val: Variant, negated: bool, target: Object)
signal on_change_speed_type(new_val: Variant, negated: bool, target: Object)
signal on_change_time_type(new_val: Variant, negated: bool, target: Object)
signal on_change_colour_type(new_val: Variant, negated: bool, target: Object)
signal on_change_steam_type(new_val: Variant, negated: bool, target: Object)


# key = array of blocks, int = number of it occurence
var _global_implemented_rules: Dictionary[PackedStringArray, int] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# Cancle drag if the player moves
	if Input.is_action_pressed("left") or \
		Input.is_action_pressed("right") or \
		Input.is_action_pressed("jump"):
			get_viewport().gui_cancel_drag()
