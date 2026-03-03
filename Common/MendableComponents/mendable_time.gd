extends Node2D


func _ready() -> void:
	pass


func _on_change_time_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
