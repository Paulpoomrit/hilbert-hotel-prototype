extends Node2D

@onready var player: Player = $"../CanvasLayer_Player/Player"
@onready var player_shadow: Player = $"../CanvasLayer_Player2/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MendingSignalHub.on_change_time_type.connect(handle_on_change_time_type)
	print('wtf')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func handle_on_change_time_type(new_val: Variant, negated: bool, target: Object):
	print(new_val, negated)
	if typeof(new_val) == TYPE_INT:
		if new_val == -1:
			print('revert')
			player.handle_death_revert()
	
	if typeof(new_val) == TYPE_STRING:
		if new_val == "Real" and negated == true:
			print("stop time")
			var tween = create_tween()
			tween.tween_property($"../CanvasLayer_Shadows/GodRay".material, "shader_parameter/speed", 0.0, 0.0)
			tween.tween_property($"../CanvasLayer_ENV/3DParallaxObject_Water/Water".material, "shader_parameter/speed", 0.0, 0.0)
			
			
		if new_val == "Real" and negated == false:
			print("resume time")




func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		player.handle_death()
