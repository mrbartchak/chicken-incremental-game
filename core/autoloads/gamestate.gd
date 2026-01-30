extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)

var wings: int = 0
var total_wings_collected: int = 0
var wing_value: int = 1

var chicken_count: int = 0
var max_chickens: int = 1

func collect_wing() -> void:
	wings += wing_value
	total_wings_collected += wing_value
	wings_changed.emit(wings)

func add_chickens(amount: int = 1) -> void:
	chicken_count += amount
	chicken_count_changed.emit(chicken_count)
