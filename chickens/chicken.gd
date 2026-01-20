class_name Chicken
extends Area2D

var max_health: int = 3
var health: int

func _ready() -> void:
	health = max_health

# ===================
#      Movement
# ===================
var start_position: Vector2
var target_position: Vector2

func pick_new_target():
	var wander_radius: float = 20.0
	var offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	target_position = start_position + offset
# ===================
#       Damage
# ===================
func take_damage(amount: int) -> void:
	health -= amount
	flash()
	$HitParticles.restart()
	if health <= 0:
		die()

func flash() -> void:
	var flash_time: float = 0.08
	$Sprite2D.modulate = Color(10, 10, 10)
	await get_tree().create_timer(flash_time).timeout
	$Sprite2D.modulate = Color(1, 1, 1)

func die() -> void:
	queue_free()
