class_name Block


extends TextureButton


@export var _block_data: BlockData = preload("uid://c80app652t07d")


var _block_type: String
var _is_enable: bool = false


func _ready() -> void:
	update_ui()


func update_ui() -> void:
	if not _block_data:
		return
	self.texture_normal = _block_data.block_texture
	_block_type = _block_data.block_type


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
	self.modulate = _block_data.hover_tint
	scale = Vector2(1.05, 1.05)
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BLOCK_HOVER)


func _on_mouse_exited() -> void:
	self.modulate = Color(1,1,1,1)
	scale = Vector2(1, 1)


func _get_drag_data(at_position: Vector2) -> Variant:
	if not _block_data:
		return
	
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BLOCK_CLICK)
	
	# Create preview icon for dragging
	var preview_block = self.duplicate()
	var preview_control_node = Control.new()
	preview_control_node.add_child(preview_block)
	preview_block.position -= self.texture_normal.get_size() / 2
	
	set_drag_preview(preview_control_node)
	return self


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BLOCK_DROP)
	
	# swap data
	var current_block_temp = _block_data
	_block_data = data._block_data
	data._block_data = current_block_temp
	
	self.update_ui()
	data.update_ui()
	
	MendingSignalHub.on_block_drop.emit(self)
	MendingSignalHub.on_block_drop.emit(data)
