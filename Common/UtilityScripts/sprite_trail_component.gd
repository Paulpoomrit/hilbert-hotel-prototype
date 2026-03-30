class_name SpriteTailComponent;
extends Node2D


@export var sprite_2d_ref: Sprite2D

## generates trail every n-th frame
@export var trail_frequency: int = 6
@export var is_trail_enable: bool = false


var parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	assert(parent)
	assert(sprite_2d_ref)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ((get_tree().get_frame() % trail_frequency == 0.0)) and is_trail_enable:
		var trail_sprite: Sprite2D = sprite_2d_ref.duplicate()
		#trail_sprite.stop()
		get_tree().root.add_child(trail_sprite)
		trail_sprite.global_position = parent.global_position
		trail_sprite.start_fading()


func toggle_enable_sprite_tail(enable: bool):
	is_trail_enable = enable
