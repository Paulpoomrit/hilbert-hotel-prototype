extends Node

const GRAMMAR_PATH = "res://Common/MendingMechanics/Parser/grammar.txt"
var _grammar_dict: Array[GrammarRule]


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
	
	# I'm turning it to a string just for demonstration
	# Feel free to keep sentence as an array
	var string_sentence: String = " ".join(sentence)
	print("Implementing: %s" % string_sentence)
	
	match string_sentence:
		"Time Is Real":
			# TODO: wire this with a signal (should be defined in MendingSignalHub.gd)
			print('yo')
