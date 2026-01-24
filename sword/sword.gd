class_name Sword
extends Area2D

var attack_damage: int = 1
var attack_radius: int = 28
var follow_speed: float = 32.0
var can_attack: bool = true
var attack_cooldown: float = 0.25
var cooldown_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var cooldown_bar: ProgressBar = $CooldownBar
@onready var attack_hitbox: CollisionShape2D = $AttackHitbox

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cooldown_bar.value = 1.0
	attack_hitbox.shape.radius = attack_radius

func _process(delta):
	var target := get_global_mouse_position()
	global_position = global_position.lerp(target, follow_speed * delta)
	collect_wings()
	update_cooldown_bar(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			try_attack()

func try_attack() -> void:
	if !can_attack:
		return
	attack()

func attack() -> void:
	can_attack = false
	cooldown_timer = 0.0
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("take_damage"):
			area.take_damage(attack_damage)
	play_swing()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func collect_wings() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("collect"):
			area.collect()

# ===================
#       Effects
# ===================
func play_swing() -> void:
	$SwingSound.pitch_scale = randf_range(0.6, 1.4)
	$SwingSound.play()
	var tween := create_tween()
	tween.tween_property(sprite, "scale", Vector2(2.0, 2.0), 0.1)
	tween.parallel().tween_property(sprite, "rotation_degrees", -30.0, 0.1)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)
	tween.parallel().tween_property(sprite, "rotation_degrees", 0.0, 0.1)

func update_cooldown_bar(delta) -> void:
	if !can_attack:
		cooldown_timer += delta
		cooldown_bar.value = cooldown_timer / attack_cooldown
	else:
		cooldown_bar.value = 1.0
