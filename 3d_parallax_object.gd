extends Node2D


@export var min_parallax : int = -20 ## Amount of parallax layers behind
@export var max_parallax : int = 10 ## Amount of parallax layers in front, main layer will not be drawn if 0 is outside the range
@export var parallax_scroll_factor : float = 0.95 ## Scroll multiplier of each parallax behind and divisor for in front
@export var parallax_scale_factor : float = 0.95 ## Scale multiplier of each parallax behind and divisor for in front
@export var parallax_modulate_factor : Color = Color(0.95, 0.95, 0.95, 1) ## Modulate multiplier of each parallax behind
@export var parallax_offset : Vector2 = Vector2(0.5, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Checks for settings errors
	assert(min_parallax < max_parallax, "Min Parallax must be a lower value than Max Parallax!")
	assert(parallax_scroll_factor != 0, "Parallax Scroll Factor must be a nonzero value!")
	assert(parallax_scale_factor != 0, "Parallax Scale Factor must be a nonzero value!")
	# Sets location to center of viewport and offsets children to reflect the new position
	var offset = position
	position = get_viewport().size
	position.x *= parallax_offset.x
	position.y *= parallax_offset.y
	offset -= position
	for child in get_children():
		if child != $Parallaxes:
			child.position += offset
	# Create first layer and disable all collisions from first copies
	var new_parallax = Parallax2D.new()
	# Set scroll, scale, color, and z index
	new_parallax.scroll_scale = Vector2(1, 1) * parallax_scroll_factor ** -max_parallax
	new_parallax.scale = Vector2(1, 1) * parallax_scale_factor ** -max_parallax
	new_parallax.modulate.r = parallax_modulate_factor.r ** -min(0, max_parallax)
	new_parallax.modulate.g = parallax_modulate_factor.g ** -min(0, max_parallax)
	new_parallax.modulate.b = parallax_modulate_factor.b ** -min(0, max_parallax)
	new_parallax.modulate.a = parallax_modulate_factor.a ** -min(0, max_parallax)
	new_parallax.z_index += max_parallax
	# Add copies of children with collisions disabled
	for child in get_children():
		if child != $Parallaxes:
			var child_copy = child.duplicate()
			# Disable collision of child if applicable
			if child_copy is CollisionShape2D or child_copy is CollisionPolygon2D:
				child_copy.disabled = true
			elif child_copy is TileMapLayer:
				child_copy.collision_enabled = false
			# Disable collision of descendants if applicable
			for collision_object in child_copy.find_children("*", "CollisionShape2D", true, false):
				collision_object.disabled = true
			for collision_object in child_copy.find_children("*", "CollisionPolygon2D", true, false):
				collision_object.disabled = true
			for collision_object in child_copy.find_children("*", "TileMapLayer", true, false):
				collision_object.collision_enabled = false
			new_parallax.add_child(child_copy)
	$Parallaxes.add_child(new_parallax)
	# Copy parallaxes to subsequent layers
	for i in range(max(0, min_parallax), max_parallax-1):
		new_parallax = new_parallax.duplicate()
		# Set scroll, scale, and z index
		new_parallax.scroll_scale *= parallax_scroll_factor
		new_parallax.scale *= parallax_scale_factor
		new_parallax.z_index -= 1
		$Parallaxes.add_child(new_parallax)
	for i in range(min_parallax, max(0, min_parallax)):
		new_parallax = new_parallax.duplicate()
		# Set scroll, scale, modulate, and z index
		new_parallax.scroll_scale *= parallax_scroll_factor
		new_parallax.scale *= parallax_scale_factor
		new_parallax.modulate *= parallax_modulate_factor
		new_parallax.z_index -= 1
		$Parallaxes.add_child(new_parallax)
	# Main layers are hidden if 0 is outside the min/max range
	if max_parallax < 0 or min_parallax > 0:
		for child in get_children():
			if child != $Parallaxes:
				child.hide()
	
