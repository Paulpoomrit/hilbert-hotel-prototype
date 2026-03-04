extends Node2D


@export var base_gravity : float = 980.0
var gravity_function = "linear"
var gravity_multiplier = Vector2(0, 1.0)


func _ready() -> void:
	pass


func update(delta: float):
	if gravity_function == "linear":
		return linear_gravity(delta, gravity_multiplier)
	elif gravity_function == "colourful":
		return colourful_gravity(delta)


func linear_gravity(delta: float, mult):
	return base_gravity*delta*mult


func colourful_gravity(delta):
	# Placeholder
	return Vector2(0, 0)


func _on_change_gravity_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
