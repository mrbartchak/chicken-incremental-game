class_name Chicken
extends Area2D

var max_health: int = 3
var health: int

func _ready() -> void:
	health = max_health

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	queue_free()
