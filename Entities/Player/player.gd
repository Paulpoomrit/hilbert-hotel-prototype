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
		controls_velocity.x = direction * SPEED
	else:
		$AnimatedSprite2D.animation = "idle"
		controls_velocity.x = move_toward(controls_velocity.x, 0, SPEED)
		
	velocity = velocity + controls_velocity
	var initial_velocity = velocity
	
	move_and_slide() # Theoretically this should never increase velocity in any direction by itself
	#print(velocity.x)
	# Remove controls_velocity from total velocity
	if velocity.x != 0:
		velocity.x -= controls_velocity.x * (velocity.x / initial_velocity.x)
	elif initial_velocity.x == 0 and controls_velocity.x != 0:
		velocity.x -= controls_velocity.x
	if velocity.y != 0:
		velocity.y -= controls_velocity.y * (velocity.y / initial_velocity.y)
	elif initial_velocity.y == 0 and controls_velocity.y != 0:
		velocity.y -= controls_velocity.y
	#print(velocity.x)
