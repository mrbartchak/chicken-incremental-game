class_name WingValueUpgrade
extends Upgrade

@export var value_increase: int

func apply() -> void:
	GameManager.wing_value += value_increase
