extends PointLight2D


var original_colour: Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_colour = self.color
	MendingSignalHub.on_change_colour_type.connect(toggle_light_colour)


func toggle_light_colour(new_val: Variant, negated: bool, target: Object) -> void:
	if target:
		return
	if typeof(new_val) == TYPE_STRING:
		if new_val != "Real":
			return
	var tween = create_tween()
	if (negated):
		tween.tween_property(self, "color", Color.WHITE, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(self, "color", original_colour, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
