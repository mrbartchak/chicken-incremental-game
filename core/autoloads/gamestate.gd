extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)

var chicken_count: int = 0
var wings: int = 0

func add_wings(amount: int = 1) -> void:
	wings += amount
	wings_changed.emit(wings)

func add_chickens(amount: int = 1) -> void:
	chicken_count += amount
	chicken_count_changed.emit(chicken_count)
