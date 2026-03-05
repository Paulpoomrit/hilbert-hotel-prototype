extends Node


signal on_block_drop(block: Block)

signal on_change_gravity_type(new_val: Variant, negated: bool, target: Object)
signal on_change_speed_type(new_val: Variant, negated: bool, target: Object)
signal on_change_time_type(new_val: Variant, negated: bool, target: Object)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
