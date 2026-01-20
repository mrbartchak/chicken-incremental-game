class_name Chicken
extends Area2D

var max_health: int = 3
var health: int

func _ready() -> void:
	health = max_health

func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if health <= 0:
		die()

func flash() -> void:
	var flash_time: float = 0.08
	$Sprite2D.modulate = Color(5, 5, 5,)
	await get_tree().create_timer(flash_time).timeout
	$Sprite2D.modulate = Color(1, 1, 1, 1)

func die() -> void:
	queue_free()
