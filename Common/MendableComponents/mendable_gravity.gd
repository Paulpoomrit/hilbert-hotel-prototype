extends Node2D


@export var base_gravity : float = 980.0
var update_function = "linear"
var gravity_multiplier = Vector2(0, 1.0)


func update(delta):
	if update_function == "linear":
		return linear_gravity(delta, gravity_multiplier)
	elif update_function == "colourful":
		return colourful_gravity(delta)


func linear_gravity(delta, mult):
	return base_gravity*delta*mult


func colourful_gravity(delta):
	# Placeholder
	return Vector2(0, 0)


# Callback function for when a signal to change gravity-related rules are sent
func _on_change_gravity_type(new_type):
	pass
