class_name Wing
extends Area2D

@export var wing_type: WingType

var pop_velocity: Vector2 = Vector2(0, -60)
var drop_gravity: float = 200.0
var stop_time: float = 0.5

var velocity: Vector2
var collectable: bool = false
var collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = wing_type.sprite
	pop_in()
	velocity = pop_velocity
	velocity.x = randf_range(-30, 30)
	stop_after_delay()


func _process(delta: float) -> void:
	velocity.y += drop_gravity * delta
	global_position += velocity * delta

func stop_after_delay() -> void:
	await get_tree().create_timer(stop_time).timeout
	drop_gravity = 0.0
	velocity = Vector2.ZERO
	collectable = true

func collect() -> void:
	if !collectable or collected:
		return
	AudioManager.play_item_collect()
	GameEffects.spawn_floating_number(GameManager.wing_value, self.global_position)
	collected = true
	GameManager.collect_wing(wing_type.base_value)
	$Sprite2D.visible = false
	queue_free()

func pop_in() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.6).from(Vector2(.2, .2))
