extends Node2D


var color_effect = "none"


func _ready() -> void:
	pass # Replace with function body.


func _on_change_colour_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
	if typeof(new_val) == TYPE_STRING:
		$Area2D/CollisionShape2D.disabled = true
		if new_val == "none":
			pass
		elif new_val == "gravity":
			$Area2D/CollisionShape2D.disabled = false
		
		color_effect = new_val
