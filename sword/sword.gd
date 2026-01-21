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
	collect_wings()

func _on_attack_timer_timeout() -> void:
	attack()
	play_swing()

func attack() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("take_damage"):
			area.take_damage(1)

func collect_wings() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("collect"):
			area.collect()

func play_swing() -> void:
	$SwingSound.pitch_scale = randf_range(0.6, 1.4)
	$SwingSound.play()
	var swing_scale: Vector2 = Vector2(2.0, 2.0)
	var swing_time: float = 0.1
	var swing_rotation: float = deg_to_rad(-90)
	$Sprite2D.scale = swing_scale
	#sprite.rotation = swing_rotation
	await get_tree().create_timer(swing_time).timeout
	$Sprite2D.scale = Vector2.ONE
	#sprite.rotation = 0.0
