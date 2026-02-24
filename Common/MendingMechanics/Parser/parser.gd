extends Node

const GRAMMAR_PATH = "res://Common/MendingMechanics/Parser/grammar.txt"
var _grammar_dict: Dictionary[String, String]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grammar_dict()


func populate_grammar_dict() -> void:	
	
	var file = FileAccess.open(GRAMMAR_PATH, FileAccess.READ)
	
	while not file.eof_reached():
		var line = file.get_line()
		
		var rhs
		var lhs
