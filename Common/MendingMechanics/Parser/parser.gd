extends Node

const GRAMMAR_PATH = "res://Common/MendingMechanics/Parser/grammar.txt"
var _grammar_dict: Array[GrammarRule]

var _identifier_dict: Dictionary[String, Object] = {
		"Player": Player,
		"Enemy": Enemy
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grammar_dict()


func populate_grammar_dict() -> void:	
	
	var file = FileAccess.open(GRAMMAR_PATH, FileAccess.READ)
	
	# iterate over each line of grammar.txt
	while not file.eof_reached():
		var line: String = file.get_line()
		
		# skip if line is empty
		if line == "" or line == " ":
			continue
		
		# skip if line is comment
		if line[0] == "#":
			continue
		
		# match everything on the lhs of the symbol ->
		var lhs_regex = RegEx.create_from_string(".+(?=(->|→))") 
		# match everything on the rhs of the symbol ->
		var rhs_regex = RegEx.create_from_string("(?<=(->|→)).+")
		
		var lhs: String = lhs_regex.search(line).get_string()
		var rhs: String = rhs_regex.search(line).get_string()
		
		# text cleaning
		lhs = lhs.replace(" ", "")
		rhs = rhs.strip_edges()
		var rhs_array: PackedStringArray = rhs.split(" ")
		
		# for checking if the grammar is loaded properly!
		# print("lhs: %s | rhs: %s" % [lhs, rhs_array])
		
		_grammar_dict.append(GrammarRule.new(lhs,rhs_array))


func is_valid(sentence: PackedStringArray) -> bool:
	var valid_grammar = search_for_valid_grammar(sentence)
	if valid_grammar == "":
		#print("invalid sentence: %s" % sentence)
		return false
	else:
		print("valid sentence: %s" % sentence)
		return true


func search_for_valid_grammar(block_combo: PackedStringArray) -> String:
	# Helper function to search for a valid rule in _grammar_dict
	for rule: GrammarRule in _grammar_dict:
		var key: String = rule.lhs
		var value: PackedStringArray = rule.rhs
		if value == block_combo:
			return key
	return ""


func implement(sentence: PackedStringArray) -> void:
	# Implement an already validated sentence
	# [So we know the structure will be grammartical according to grammar.gd]
	
	var string_sentence: String = " ".join(sentence)
	print("Implementing: %s" % string_sentence)
	
	# Extracting info
	var info = extract_val_neg_target(string_sentence)
	var new_val: Variant = info[0]
	var negated: bool = info[1]
	var target: Object = info[2]
	
	# print("New Val: %s | Negated: %s | Target: %s" % [new_val, negated, target])
	
	send_signal(sentence, new_val, negated, target)


func reverse(sentence: PackedStringArray) -> void:
	var string_sentence: String = " ".join(sentence)
	
	# Extracting info
	var info = extract_val_neg_target(string_sentence)
	var new_val: Variant = info[0]
	var negated: bool = false # returning negated sentence to its default
	var target: Object = info[2]
	
	if typeof(new_val) == TYPE_INT:
		new_val = 1 # Assuming base quantifier will always be 1
	
	send_signal(sentence, new_val, negated, target)


func extract_val_neg_target(string_sentence: String) -> Array:
	# Extracting info
	var new_val_regex = RegEx.create_from_string("(Real|1|2|3|- 1|- 2|- 3|Gravity|Heavy)") 
	var new_val = new_val_regex.search(string_sentence).get_string()
	new_val = new_val.replacen(" ", "")
	if new_val.is_valid_int():
		new_val = int(new_val)
		
	var negated: bool = false
	var negated_regex = RegEx.create_from_string("Not")
	if  negated_regex.search(string_sentence):
		negated = true
		
	var target: Object = null
	var target_regex = RegEx.create_from_string("Player|Enemy")
	var found_target = target_regex.search(string_sentence)
	if found_target:
		var target_string = found_target.get_string()
		if target_string in _identifier_dict:
			target = _identifier_dict[target_string]
	return [new_val, negated, target]


func send_signal(sentence: PackedStringArray, new_val: Variant, negated: bool, target: Object) -> void:
	if sentence[0] == "Gravity" or sentence[1] == "Gravity":
		MendingSignalHub.on_change_gravity_type.emit(new_val, negated, target)
	elif sentence[0] == "Speed" or sentence[1] == "Speed":
		MendingSignalHub.on_change_speed_type.emit(new_val, negated, target)
	elif sentence[0] == "Time" or sentence[1] == "Time":
		MendingSignalHub.on_change_time_type.emit(new_val, negated, target)
	elif sentence[0] == "Colour" or sentence[1] == "Colour":
		MendingSignalHub.on_change_colour_type.emit(new_val, negated, target)
	elif sentence[0] == "Steam" or sentence[1] == "Steam":
		MendingSignalHub.on_change_steam_type.emit(new_val, negated, target)
