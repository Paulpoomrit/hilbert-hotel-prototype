class_name Block


extends TextureButton


@export var _block_type: String = "null"
@export var _hover_tint: Color = Color(0.41, 0.41, 0.41, 1.0)


var _is_enable: bool = false


func get_block_type() -> String:
	return _block_type


func set_block_type(new_type: String) -> void:
	_block_type = new_type


func enable_block() -> void:
	_is_enable = true
	# handle block enable effects


func disable_block() -> void:
	_is_enable = false
	# handle block disable effects


func _on_mouse_entered() -> void:
	self.modulate = _hover_tint
	scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	self.modulate = Color(1,1,1,1)
	scale = Vector2(1, 1)
