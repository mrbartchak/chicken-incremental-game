extends Node

signal wings_changed(amount: int)
var wings: int = 0:
	set(value):
		wings = value
		wings_changed.emit(wings)

func add_wings(amount: int = 1) -> void:
	wings += amount
	wings_changed.emit(wings)
