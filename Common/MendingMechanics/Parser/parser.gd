extends Node

const GRAMMAR_PATH = "res://Common/MendingMechanics/Parser/grammar.txt"
var _grammar_dict: Dictionary[String, PackedStringArray]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grammar_dict()
	cky_recognition(["Gravity", "Is", "Real"])


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
	
	print(_grammar_dict)


func cky_recognition(sentence: PackedStringArray) -> bool:
	
	if sentence[1] != "Is":
		print("The sentence should always contain the 'Is' Operator")
		return false
	
	sentence.remove_at(1)
	
	var table: Array[Array]
	for row in len(sentence):
		table.append([])
		for col in len(sentence):
			table[row].append([])
	
	for j in range(1, len(sentence) + 1):
		
		for key: String in _grammar_dict:
			var value: PackedStringArray = _grammar_dict[key]
			
			if value == PackedStringArray([sentence[j-1]]):
				table[j-1][j-1].append(key)
				
				var another_key = search_for_valid_grammar([key])
				if another_key != key:
					table[j-1][j-1].append(another_key)
		
		for i in range(j-2, -1, -1):
			for k in range(i, j):
				print(k)
				
				for block_b in table[j-1][j-1]:
					for block_a in table[i][k]:
						var block_combo: PackedStringArray
						block_combo.append(block_a)
						block_combo.append(block_b)
						
						for key: String in _grammar_dict:
							var value: PackedStringArray = _grammar_dict[key]
					
							if value == block_combo:
								table[i][j-1].append(key)
	
	print(table)
	
	if (len(table[0][len(sentence)-1]) > 0 and table[0][len(sentence)-1][0] == "S"):
		print("valid sentence")
		return true
	else:
		print("invalid sentence")
		return false


func search_for_valid_grammar(block_combo: PackedStringArray) -> String:
	for key: String in _grammar_dict:
		var value: PackedStringArray = _grammar_dict[key]
		if value == block_combo:
			return key
	return ""
