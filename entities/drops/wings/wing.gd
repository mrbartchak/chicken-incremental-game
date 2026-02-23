class_name Wing
extends Area2D

@export var wing_type: WingType

var magnetic_range: float = 60.0
var magnetic_strength: float = 10.0

var pop_velocity: Vector2 = Vector2(0, -60)
var drop_gravity: float = 200.0
var stop_time: float = 0.5

var velocity: Vector2
var collectable: bool = false
var collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = wing_type.sprite
	_pop_in()

func _process(delta: float) -> void:
	if collectable:
		_handle_magnetism(delta)
	else:
		velocity.y += drop_gravity * delta
		global_position += velocity * delta

func collect() -> void:
	if !collectable or collected:
		return
	collected = true
	sprite.visible = false
	AudioManager.play_item_collect()
	GameManager.collect_wing(wing_type.base_value, self.global_position)
	queue_free()

func _handle_magnetism(delta) -> void:
	var cursor_pos: Vector2 = get_global_mouse_position()
	var distance: float = global_position.distance_to(cursor_pos)
	
	if distance < magnetic_range:
		var magnetic_weight: float = (1.0 - distance/magnetic_range) * magnetic_strength
		self.global_position = global_position.lerp(cursor_pos, magnetic_weight * delta)

func _pop_in() -> void:
	_play_pop_tween()
	velocity = pop_velocity
	velocity.x = randf_range(-30, 30)
	await _stop_after_delay()
	collectable = true

func _stop_after_delay() -> void:
	await get_tree().create_timer(stop_time).timeout
	drop_gravity = 0.0
	velocity = Vector2.ZERO

func _play_pop_tween() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.6).from(Vector2(.2, .2))
