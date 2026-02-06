class_name AttackSpeedUpgrade
extends Upgrade

@export var speed_increase: float

func apply() -> void:
	GameManager.attack_speed -= speed_increase
