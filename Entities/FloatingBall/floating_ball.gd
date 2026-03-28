extends RigidBody2D


@onready var _mendable_time = $MendableTime
var _saved_linear_velocity : Vector2
var _saved_angular_velocity : float
var _time_stopped : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(position)
	$Sprite2D.frame = randi_range(0, 3)
	$Sprite2D.rotate(randf_range(0, 2*PI))
	angular_velocity = randf_range(-PI/4, PI/4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity += get_gravity() * state.step
	state.linear_velocity -= ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale * state.step
	var time_multiplier = _mendable_time.get_time_multiplier()
	if time_multiplier == 0:
		lock_rotation = true
		freeze = true
		# Stops existing velocities
		if not _time_stopped:
			_saved_linear_velocity = linear_velocity
			_saved_angular_velocity = angular_velocity
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		set_collision_layer_value(1, true)
		_time_stopped = true
		return
	else:
		lock_rotation = false
		freeze = false
		# Restores saved velocities if previous call was frozen
		if _time_stopped:
			linear_velocity = _saved_linear_velocity
			angular_velocity = _saved_angular_velocity
		_time_stopped = false
		set_collision_layer_value(1, false)
		if time_multiplier > 0:
			# TODO: Adjust up simulation rate
			_mendable_time.update_record(state.step*time_multiplier, [position, state.angular_velocity])
		else:
			var frame_data = _mendable_time.pop_record(state.step*-time_multiplier)
			position = frame_data[0]
			state.angular_velocity = frame_data[1]
			return
