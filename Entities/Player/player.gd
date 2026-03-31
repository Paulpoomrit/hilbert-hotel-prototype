class_name Player

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var controls_velocity = Vector2(0.0, 0.0)
var jumping := false
var running := false
@onready var _mendable_speed = $MendableSpeed
@onready var _sprite_2d = $Sprite2D


func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	var time_multiplier = $MendableTime.get_time_multiplier()
	var speed_multiplier = _mendable_speed.get_speed_multiplier()
	# Sets animation speeds
	$AnimationTree.set("parameters/TimeMultiplier/scale", time_multiplier)
	$AnimationTree.set("parameters/StateMachine/BlendTree/RunSpeedMultiplier/scale", speed_multiplier)
	# Rewind time if time speed is backwards
	if time_multiplier < 0:
		var frame_data = $MendableTime.pop_record(delta*-time_multiplier)
		position = frame_data[0]
		velocity = frame_data[1]
		_sprite_2d.flip_h = frame_data[2]
		running = frame_data[3]
		_sprite_2d.frame = frame_data[4]
		$AnimationTree.active = false
		return
	# Do nothing if time is frozen
	elif time_multiplier == 0:
		$AnimationTree.active = false
		return
	else:
		$AnimationTree.active = true
	
	var temp = $MendableColour/GravityArea.collision_mask
	$MendableColour/GravityArea.collision_mask = $MendableColour/GravityArea.collision_mask & ~collision_layer
	await get_tree().physics_frame
	velocity += $MendableGravity.modify_gravity(get_gravity()) * delta * time_multiplier
	$MendableColour/GravityArea.collision_mask = temp
	
	# Handle jump.
	jumping = false
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
	
	var direction := Input.get_axis("left", "right")
	if direction:
		running = true
		if direction < 0:
			_sprite_2d.flip_h = true
		else:
			_sprite_2d.flip_h = false
		controls_velocity.x = direction * SPEED * speed_multiplier
	else:
		running = false
		controls_velocity.x = move_toward(controls_velocity.x, 0, SPEED * abs(speed_multiplier))
		
	var natural_velocity = velocity
	velocity = velocity + controls_velocity
	var initial_velocity = velocity
	
	velocity *= time_multiplier
	move_and_slide() # Never increases velocity and doesn't take custom delta values
	velocity /= time_multiplier
	
	# Remove controls_velocity from total velocity
	if abs(velocity.x) >= abs(initial_velocity.x):
		velocity.x -= controls_velocity.x
	elif natural_velocity.x * initial_velocity.x < 0 or (abs(natural_velocity.x) > 0 and initial_velocity.x == 0):
		velocity.x += natural_velocity.x
	else:
		velocity.x -= controls_velocity.x * (velocity.x / initial_velocity.x)
		
	if abs(velocity.y) >= abs(initial_velocity.y):
		velocity.y -= controls_velocity.y
	elif natural_velocity.y * initial_velocity.y < 0 or (abs(natural_velocity.y) > 0 and initial_velocity.y == 0):
		velocity.y += natural_velocity.y
	else:
		velocity.y -= controls_velocity.y * (velocity.y / initial_velocity.y)
		
	# Friction
	if is_on_floor():
		velocity.x *= abs($MendableGravity.get_gravity_direction().normalized().x)
	
	# Save this frame's final result for MendableTime
	$MendableTime.update_record(delta, [position, velocity, _sprite_2d.flip_h, running, _sprite_2d.frame])


func handle_death() -> void:
	_sprite_2d.use_parent_material = false
	var tween = create_tween()
	tween.tween_property(_sprite_2d.material, "shader_parameter/dissolve_value", 1.0, 0.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_sprite_2d.material, "shader_parameter/dissolve_value", 0.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func handle_death_revert() -> void:
	_sprite_2d.use_parent_material = false
	var tween = create_tween()
	tween.tween_property(_sprite_2d.material, "shader_parameter/dissolve_value", 1.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	## TODO: handle parent material: _sprite_2d.use_parent_material = true
