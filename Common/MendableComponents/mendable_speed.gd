extends Node2D


var update_function = "linear"
var speed_multiplier = 1.0


func get_speed_multiplier():
	if update_function == "linear":
		return linear_speed()


func linear_speed():
	return speed_multiplier
