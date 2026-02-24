extends Node

const GRAMMAR_PATH = "res://Common/MendingMechanics/Parser/grammar.txt"
var _grammar_dict: Dictionary[String, PackedStringArray]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grammar_dict()
	is_valid(["Gravity", "Is", "Real"])
	is_valid(["Gravity", "Is", "Not", "Real"])


func populate_grammar_dict() -> void:	
	
	var file = FileAccess.open(GRAMMAR_PATH, FileAccess.READ)
	
	# iterate over each line of grammar.txt
	while not file.eof_reached():
		var line: String = file.get_line()
		
		# skip if line is empty
		if line == "" or line == " ":
			continue
		
		# match everything on the lhs of the symbol ->
		var lhs_regex = RegEx.create_from_string(".+(?=->)") 
		# match everything on the rhs of the symbol ->
		var rhs_regex = RegEx.create_from_string("(?<=->).+")
		
		var lhs: String = lhs_regex.search(line).get_string()
		var rhs: String = rhs_regex.search(line).get_string()
		
		# text cleaning
		lhs = lhs.replace(" ", "")
		rhs = rhs.strip_edges()
		var rhs_array: PackedStringArray = rhs.split(" ")
		
		# print("lhs: %s | rhs: %s" % [lhs, rhs_array])
		
		_grammar_dict[lhs] = rhs_array
	
	# print(_grammar_dict)

func is_valid(sentence: PackedStringArray) -> bool:
	var valid_grammar = search_for_valid_grammar(sentence)
	if valid_grammar == "":
		print("invalid sentence: %s" % sentence)
		return false
	else:
		print("valid sentence: %s" % sentence)
		return true

func search_for_valid_grammar(block_combo: PackedStringArray) -> String:
	for key: String in _grammar_dict:
		var value: PackedStringArray = _grammar_dict[key]
		if value == block_combo:
			return key
	return ""
