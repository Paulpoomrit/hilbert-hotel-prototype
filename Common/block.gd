class_name Block


extends Node


@onready var _sprite_2d: Sprite2D = $Sprite2D
@export var _block_type: String = "null"
var _previous_block: Block = null
var _next_block: Block = null
var _is_enable: bool = false


func get_block_type() -> String:
	return _block_type


func set_block_type(new_type: String) -> void:
	_block_type = new_type


func get_previous_block() -> Block:
	return _previous_block


func get_next_block() -> Block:
	return _next_block


func set_previous_block(new_prev_block: Block) -> void:
	_previous_block = new_prev_block


func set_next_block(new_next_block: Block) -> void:
	_next_block = new_next_block


func is_first_node() -> bool:
	if _previous_block == null:
		return true
	else:
		return false


func is_last_node() -> bool:
	if _next_block == null:
		return true
	else:
		return false


func enable_block() -> void:
	_is_enable = true
	# handle block enable effects


func disable_block() -> void:
	_is_enable = false
	# handle block disable effects
