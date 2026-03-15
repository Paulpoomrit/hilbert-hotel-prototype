@tool
extends Area2D


@export var push_strength : float = 1960.0 ## Push strength of stema when it is heavy
@export var damage_tick_rate : float = 0.25 ## Amount of time required for a damage tick
@export var base_damage : int = 1 ## Amount of damage inflicted per damage tick

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var damage : int
var overlapping_bodies : Dictionary
var collosion_default: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = base_damage
	collosion_default = not $CollisionShape2D.disabled
	MendingSignalHub.on_change_steam_type.connect(_on_change_steam_property)


func _physics_process(delta: float) -> void:
	# Sets scale to default if either scale is at 0
	if scale.x == 0 or scale.y == 0:
		scale = Vector2(1.0, 1.0)
	# Otherwise, scale the collision shape to the new scale and set scale back to 1.0
	elif scale != Vector2(1.0, 1.0):
		for i in $CollisionShape2D.shape.points.size():
			$CollisionShape2D.shape.points[i] *= scale
		scale = Vector2(1.0, 1.0)
	
	if not Engine.is_editor_hint():
		# Increments all overlapping bodies' timers and damage them if ready
		for body in overlapping_bodies:
			overlapping_bodies[body] += delta
			if overlapping_bodies[body] > damage_tick_rate:
				# Damage the overlapping body and reset time
				# TODO
				overlapping_bodies[body] = fmod(overlapping_bodies[body], damage_tick_rate)


func _on_change_steam_property(new_val: Variant, negated: bool, target: Object):
	if new_val == "Danger":
		if negated:
			damage = 0
		else:
			damage = base_damage
	elif new_val == "Heavy":
		if negated:
			gravity = 0.0
		else:
			gravity = push_strength
	elif new_val == "Real":
		print('real;')
		handle_steam_reality(not negated)


func _on_body_entered(body: Node2D) -> void:
	if not Engine.is_editor_hint():
		if body is Player:
			overlapping_bodies[body.get_instance_id()] = 0


func _on_body_exited(body: Node2D) -> void:
	if not Engine.is_editor_hint():
		overlapping_bodies.erase(body.get_instance_id())


func handle_steam_reality(is_real: bool) -> void:
	self.visible = is_real
	if (is_real and collosion_default): # to prevent parallax obj collisions
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true
