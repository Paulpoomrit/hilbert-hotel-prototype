extends Enemy


@export var attack_rate : float = 2
@export var projectile_speed : float = 10.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var _attack_timer : float = 0.0
var _player_ref : Node2D = null
var _projectile_scene : PackedScene = preload("res://Entities/Enemy/RangedEnemy/RangedEnemyProjectile.tscn")
var _attacking : bool = false
@onready var _sprite_2d = $Sprite2D
@onready var _animation_tree = $AnimationTree


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if _player_ref and not _attacking:
		if _player_ref.global_position < global_position:
			_sprite_2d.flip_h = false
		else:
			_sprite_2d.flip_h = true
		_attack_timer += delta
		if _attack_timer >= attack_rate:
			# Play attack animation
			_animation_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			# Reset attack timer
			_attack_timer = fmod(_attack_timer, attack_rate)
			# Attack windup
			_attacking = true
			await get_tree().create_timer(0.3).timeout
			# Throws projectile at player's current location
			if _player_ref:
				var projectile = _projectile_scene.instantiate()
				projectile.position = position
				projectile.linear_velocity = Vector2(300.0, 0.0)
				projectile.point_to(_player_ref.global_position)
				get_parent().add_child(projectile)
			_attacking = false
	else:
		_attack_timer = 0.0
	
	move_and_slide()


func _on_throwable_range_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_ref = body


func _on_throwable_range_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_ref = null
