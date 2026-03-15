extends Node2D


var color_effect = "none"
var bw_material: ShaderMaterial = ShaderMaterial.new()
const BW = preload("uid://bkxiydok4qfbh")


func _ready() -> void:
	MendingSignalHub.on_change_colour_type.connect(_on_change_colour_type)
	
	$GravityArea/CollisionShape2D.disabled = true
	
	bw_material.shader = BW
	bw_material.set_shader_parameter("strength", 0.0)
	
	# Removes parent from effects of gravity
	var parent = get_parent()
	if parent:
		pass
	parent.material = bw_material


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
		$GravityArea/CollisionShape2D.disabled = true
		if new_val == "none":
			pass
		elif new_val == "Gravity":
			$GravityArea/CollisionShape2D.disabled = false
		elif new_val == "Real" and not negated:
			handle_colour_real()
		elif new_val == "Real" and negated:
			handle_colour_not_real()
		
		color_effect = new_val


## This assumes that 'Use Parent Material' is being turned on
## in AnimatedSprite2D under the given parent node
func handle_colour_real() -> void:
	var parent = get_parent()
	parent.material.set_shader_parameter("strength", 0.0)


func handle_colour_not_real() -> void:
	print('yo')
	var parent = get_parent()
	parent.material.set_shader_parameter("strength", 1.0)
