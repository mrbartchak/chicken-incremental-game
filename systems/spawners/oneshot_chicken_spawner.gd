class_name OneshotChickenSpawner
extends Node

@export var chicken_scene: PackedScene
@export var chicken_container: Node2D
@export var spawn_count: int = 0
@export var spawn_area: Rect2 = Rect2(44, 26, 232, 128)
@export var active: bool = true
@export var active_types: Dictionary = {
	"basic": true,
	"silver": false
}

var chicken_types: Dictionary = {
	"basic": preload("res://entities/chickens/types/basic_chicken.tres"),
	"silver": preload("res://entities/chickens/types/silver_chicken.tres")
}

func _ready() -> void:
	await get_tree().create_timer(10.0).timeout
	_spawn_all()

func _spawn_all() -> void:
	for i in range(spawn_count):
		_spawn_chicken()

func _spawn_chicken() -> void:
	var chicken: Chicken = chicken_scene.instantiate()
	chicken.chicken_type = _get_random_chicken_type()
	chicken_container.add_child(chicken)
	chicken.position = _get_spawn_position()
	GameManager.add_chicken()

func _get_active_types() -> Array[String]:
	var active_array: Array[String] = []
	for type: String in active_types:
		if active_types[type]:
			active_array.append(type)
	return active_array

func _get_random_chicken_type() -> ChickenType:
	return chicken_types[_get_active_types().pick_random()]

func _get_spawn_position() -> Vector2:
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	return pos
