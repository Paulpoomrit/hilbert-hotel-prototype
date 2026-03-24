extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity += get_gravity() * state.step
	state.linear_velocity -= ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale * state.step


func point_to(dest: Vector2):
	var new_angle = global_position.angle_to_point(dest)
	$Sprite2D.rotation = new_angle
	linear_velocity = linear_velocity.rotated(new_angle)
