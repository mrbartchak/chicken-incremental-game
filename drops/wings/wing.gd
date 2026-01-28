class_name Wing
extends Area2D

@export var value: int = 1

var pop_velocity: Vector2 = Vector2(0, -60)
var drop_gravity: float = 200.0
var stop_time: float = 0.6

var velocity: Vector2
var collectable: bool = false
var collected: bool = false

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
	await get_tree().create_timer(0.1).timeout
	collectable = true

func collect() -> void:
	if !collectable or collected:
		return
	collected = true
	GameState.add_wings(1)
	$Sprite2D.visible = false
	$CollectSound.play()
	await $CollectSound.finished
	queue_free()

func pop_in() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.6).from(Vector2(0, 0))
