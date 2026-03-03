extends Node2D


var update_function = "linear"
var speed_multiplier = 1.0


func _ready() -> void:
	pass


func get_speed_multiplier():
	if update_function == "linear":
		return linear_speed()


func linear_speed():
	return speed_multiplier


func _on_change_speed_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
