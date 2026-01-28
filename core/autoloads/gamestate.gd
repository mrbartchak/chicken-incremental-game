extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)

var wings: int = 0
var total_wings_collected: int = 0

var chicken_count: int = 0
var max_chickens: int = 1

func add_wings(amount: int = 1) -> void:
	wings += amount
	total_wings_collected += amount
	wings_changed.emit(wings)

func add_chickens(amount: int = 1) -> void:
	chicken_count += amount
	chicken_count_changed.emit(chicken_count)
