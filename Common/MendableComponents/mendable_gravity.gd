extends Node2D


var real = true
var gravity_direction = Vector2(0, 1.0)
var gravity_multiplier = 1.0


func _ready() -> void:
	MendingSignalHub.on_change_gravity_type.connect(_on_change_gravity_type)


func get_gravity_direction():
	return gravity_direction


func modify_gravity(grav: Vector2):
	return (
			(grav
			- (ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity"))
			+ (gravity_direction * ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_multiplier))
		if real
		else Vector2(0.0, 0.0))


func _on_change_gravity_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
	if typeof(new_val) == TYPE_INT:
		gravity_multiplier = new_val
		if negated:
			gravity_multiplier *= -1
	elif new_val == "Real":
		real = !negated
