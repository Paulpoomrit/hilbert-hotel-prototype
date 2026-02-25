class_name GrammarRule


extends Node


var lhs: String
var rhs: PackedStringArray


func _init(lhs_new: String, rhs_new: PackedStringArray) -> void:
	self.lhs = lhs_new
	self.rhs = rhs_new
