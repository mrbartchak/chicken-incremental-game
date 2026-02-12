class_name Sword
extends Area2D

var attack_damage: int = 5
var attack_radius: int = 10

var attack_cooldown: float = 1.0
var cooldown_timer: float = 0.0
var cooldown_ready: bool = true

var over_ui: bool = false

@onready var sword_sprite: Sprite2D = $SwordSprite
@onready var cooldown_bar: ProgressBar = $CooldownBar
@onready var attack_hitbox: CollisionShape2D = $AttackHitbox

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.stats_changed.connect(_update_stats)
	cooldown_bar.value = 1.0
	cooldown_timer = attack_cooldown
	attack_hitbox.shape.radius = attack_radius
	attack_cooldown = GameManager.attack_speed
	sword_sprite.show()
	Cursor.hide_cursor()

func _process(delta):
	if not cooldown_ready:
		cooldown_timer += delta
	over_ui = _is_mouse_over_ui()
	if over_ui:
		sword_sprite.hide()
		Cursor.show_cursor()
	else:
		sword_sprite.show()
		Cursor.hide_cursor()
	_handle_cursor_follow(delta)
	_collect_wings()
	queue_redraw()
	#_update_cooldown_bar(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			try_attack()

func _update_stats() -> void:
	attack_cooldown = GameManager.attack_speed
	queue_redraw()

func try_attack() -> void:
	if !cooldown_ready or over_ui:
		return
	_attack()

func _attack() -> void:
	cooldown_ready = false
	cooldown_timer = 0.0
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("take_damage"):
			area.take_damage(attack_damage)
	_play_swing()
	await get_tree().create_timer(attack_cooldown).timeout
	cooldown_ready = true

func _collect_wings() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in areas:
		if area.has_method("collect"):
			area.collect()

# ===================
#      Visuals
# ===================
func _handle_cursor_follow(delta: float) -> void:
	var follow_speed: float = 32.0
	var target := get_global_mouse_position()
	global_position = global_position.lerp(target, follow_speed * delta)

func _play_swing() -> void:
	$SwingSound.pitch_scale = randf_range(0.6, 1.4)
	$SwingSound.play()
	var tween := create_tween()
	tween.tween_property(sword_sprite, "scale", Vector2(2.0, 2.0), 0.1)
	tween.parallel().tween_property(sword_sprite, "rotation_degrees", -30.0, 0.1)
	tween.tween_property(sword_sprite, "scale", Vector2.ONE, 0.1)
	tween.parallel().tween_property(sword_sprite, "rotation_degrees", 0.0, 0.1)

#func _update_cooldown_bar(delta) -> void:
	#if !cooldown_ready:
		#cooldown_timer += delta
		#cooldown_bar.value = cooldown_timer / attack_cooldown
	#else:
		#cooldown_bar.value = 1.0

func _draw() -> void:
	if over_ui:
		return
	var fill_percent: float = minf(cooldown_timer / attack_cooldown, 1.0)
	var outline_thickness: float = 1.0
	draw_arc(Vector2.ZERO, attack_radius, 0, TAU, 60, Color(1, 1, 1, 0.05), outline_thickness)
	if fill_percent > 0:
		draw_circle(Vector2.ZERO, (attack_radius - outline_thickness / 2 ) * fill_percent, Color(1, 1, 1, 0.05))

func _is_mouse_over_ui() -> bool:
	var hovered: Control = get_viewport().gui_get_hovered_control()
	return hovered != null and hovered.is_in_group("interactive_ui")
