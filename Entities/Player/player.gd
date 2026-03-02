extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
var controls_velocity = Vector2(0.0, 0.0)


func _ready() -> void:
	$AnimatedSprite2D.play()


func _physics_process(delta: float) -> void:	
	# Add the gravity.
	velocity += $MendableGravity.update(delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		$AnimatedSprite2D.animation = "walk"
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		controls_velocity.x = direction * SPEED * $MendableSpeed.get_speed_multiplier()
	else:
		$AnimatedSprite2D.animation = "idle"
		controls_velocity.x = move_toward(controls_velocity.x, 0, SPEED * $MendableSpeed.get_speed_multiplier())
		
	var natural_velocity = velocity
	velocity = velocity + controls_velocity
	var initial_velocity = velocity
	
	move_and_slide() # Theoretically this should never increase velocity in any direction by itself
	
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
