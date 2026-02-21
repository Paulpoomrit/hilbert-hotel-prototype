extends Node2D


@export var repeat_count = 20
@export var repeat_scroll_factor = 0.95
@export var repeat_scale_factor = 0.95
@export var repeat_color : Color = Color(0.95, 0.95, 0.95, 1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add parallax layers
	if repeat_count > 0:
		var parallax_layers = []
		# First parallax layer
		for parallax in find_children("*", "Parallax2D"):
			var new_parallax_layer = parallax.duplicate()
			# Disable CollisionShape2Ds
			for collision_object in new_parallax_layer.find_children("*", "CollisionShape2D", true, false):
				collision_object.disabled = true
			# Disable CollisionPolygon2Ds
			for collision_object in new_parallax_layer.find_children("*", "CollisionPolygon2D", true, false):
				collision_object.disabled = true
			# Disable TileMapLayer collisions
			for collision_object in new_parallax_layer.find_children("*", "TileMapLayer", true, false):
				collision_object.collision_enabled = false
				print(collision_object.collision_enabled)
			# Set scale, scroll, and colour
			new_parallax_layer.scale *= repeat_scale_factor
			new_parallax_layer.scroll_scale *= repeat_scroll_factor
			new_parallax_layer.modulate *= repeat_color
			# Set offset (add total bound of parallax and its descendants * scale factor / 2)
			# todo
			parallax_layers.append(new_parallax_layer)
			
		# Subsequent parallax layers
		var size = parallax_layers.size()
		for i in range(repeat_count-1):
			for j in range(size):
				var new_parallax_layer = parallax_layers[i*size+j].duplicate()
				new_parallax_layer.scale *= repeat_scale_factor
				new_parallax_layer.scroll_scale *= repeat_scroll_factor
				new_parallax_layer.modulate *= repeat_color
				parallax_layers.append(new_parallax_layer)
		
		for i in range(parallax_layers.size()-1, -1, -1):
			$LowerLayers.add_child(parallax_layers[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
