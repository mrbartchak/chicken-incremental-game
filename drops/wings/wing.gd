class_name Wing
extends Area2D

@export var value: int = 1

var pop_velocity: Vector2 = Vector2(0, -60)
var drop_gravity: float = 200.0
var stop_time: float = 0.5

var velocity: Vector2
var collectable: bool = false
var collected: bool = false

@onready var collect_sound: AudioStreamPlayer = $CollectSound

func _ready() -> void:
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
	collect_sound.play()
	collected = true
	GameState.add_wings(1)
	$Sprite2D.visible = false
	await collect_sound.finished
	queue_free()

func pop_in() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.6).from(Vector2(.2, .2))
