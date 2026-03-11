extends Node2D


var real = true
var time_function = "linear"
var time_multiplier = 1.0
var record_duration : float = 5.0
var record_data : Array[Array]


func _ready() -> void:
	MendingSignalHub.on_change_time_type.connect(_on_change_time_type)


func get_time_multiplier():
	if not real:
		return 0.0
	elif time_function == "linear":
		return time_multiplier


func update_record(delta: float, new_entry):
	# Increment age of existing entries
	for entry in record_data:
		entry[0] += delta
	# Remove old enough entries
	while record_data.size() > 0 and record_data[0][0] > record_duration:
		record_data.remove_at(0)
	# Add newest entry
	record_data.append([0.0, new_entry])


func pop_record(past_time: float):
	# Decrement time of existing entries
	for entry in record_data:
		entry[0] -= past_time
	# Remove entries that should no longer exist
	while record_data.size() > 1 and record_data[-2][0] < 0:
		record_data.remove_at(-1)
	return record_data[-1][1]


func record_is_empty():
	return record_data.is_empty() or (record_data.size() == 1 and record_data[0][0] < 0)


func _on_change_time_type(new_val, negated : bool = false, target = null):
	if target:
		var parent = get_parent()
		if not parent or not is_instance_of(parent, target):
			return
	if typeof(new_val) == TYPE_INT:
		time_multiplier = new_val
		if negated:
			time_multiplier *= -1
	elif new_val == "Real":
		real = !negated
	
