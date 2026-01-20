class_name Chicken
extends Area2D

@export var wing_scene: PackedScene
var max_health: int = 1
var health: int
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	health = max_health
	pick_new_target()
	$WanderTimer.timeout.connect(pick_new_target)

func _process(delta: float) -> void:
	move_towards_target(delta)

# ===================
#      Movement
# ===================
var target_position: Vector2
var movement_speed: int = 15
var wander_radius: float = 10.0

func pick_new_target() -> void:
	var offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	$WanderTimer.wait_time = randf_range(0.8,2.0)
	target_position = global_position + offset

func move_towards_target(delta) -> void:
	var dir = target_position - global_position
	if dir.length() < 2.0:
		return
	set_facing(dir.x)
	global_position += dir.normalized() * movement_speed * delta
	
func set_facing(direction_x: float) -> void:
	if direction_x < 0:
		sprite.play("walk_left")
	elif direction_x > 0:
		sprite.play("walk right")

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
	sprite.modulate = Color(10, 10, 10)
	await get_tree().create_timer(flash_time).timeout
	sprite.modulate = Color(1, 1, 1)

func die() -> void:
	drop_wing()
	queue_free()

# ===================
#        Drops
# ===================
func drop_wing() -> void:
	var wing: Area2D = wing_scene.instantiate()
	wing.global_position = global_position
	get_parent().add_child(wing)
