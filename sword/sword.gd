class_name Sword
extends Area2D

var follow_speed: float = 32.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _process(delta):
	var target := get_global_mouse_position()
	global_position = global_position.lerp(target, follow_speed * delta)

func _on_attack_timer_timeout() -> void:
	attack()
	play_swing()

func attack() -> void:
	var bodies: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in bodies:
		if area.has_method("take_damage"):
			area.take_damage(1)

func play_swing() -> void:
	$SwingSound.pitch_scale = randf_range(0.6, 1.4)
	$SwingSound.play()
	var swing_scale: Vector2 = Vector2(1.5, 1.5)
	var swing_time: float = 0.08
	var swing_rotation: float = deg_to_rad(-90)
	$Sprite2D.scale = swing_scale
	sprite.rotation = swing_rotation
	await get_tree().create_timer(swing_time).timeout
	$Sprite2D.scale = Vector2.ONE
	sprite.rotation = 0.0
