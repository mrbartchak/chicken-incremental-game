extends Node

signal wing_count_changed(amount)
var wings: int = 0

func add_wings(amount: int = 1) -> void:
	wings += amount
	wing_count_changed.emit(wings)

func reset() -> void:
	wings = 0
