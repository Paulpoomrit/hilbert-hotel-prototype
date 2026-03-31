extends Node2D

var should_kill = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MendingSignalHub.on_change_steam_type.connect(handle_steam)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_steam_body_entered(body: Node2D) -> void:
	#print(body)
	#if should_kill:
		#MendingSignalHub.on_change_time_type.emit("Real", true, null)
		#$CanvasLayer_Player/Player.handle_death()

func handle_steam(new_val: Variant, negated: bool, target: Object):
	should_kill = negated
