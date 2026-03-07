extends Node2D


var color_effect = "none"


func _ready() -> void:
	# Removes parent from effects of gravity
	var parent = get_parent()
	if parent:
		pass


func negate_parent_pull(dir: Vector2 = Vector2(0.0, 0.0)):
	if position == Vector2(0.0, 0.0):
		return Vector2(sign(dir.x), sign(dir.y)) * $GravityArea.gravity
	else:
		return position.direction_to(Vector2(0.0, 0.0)) * $GravityArea.gravity


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
