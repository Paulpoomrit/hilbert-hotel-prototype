extends Sprite2D


func update_alpha(new_value: float):
	modulate.a = new_value
	if new_value == 0.0:
		self.queue_free()

func start_fading():
	var tween = get_tree().create_tween()
	tween.tween_method(update_alpha, 0.8, 0.0, 1.0)
