class_name ChickenSpawner
extends Node

@export var chicken_scene: PackedScene
@export var chicken_container: Node2D
@export var spawn_area: Rect2 = Rect2(44, 26, 232, 128)

var chicken_types: Dictionary = {
	"basic": preload("res://entities/chickens/types/basic_chicken.tres"),
	"silver": preload("res://entities/chickens/types/silver_chicken.tres")
}

var spawn_timer: float = 0.0

func _ready() -> void:
	spawn_timer = 0.0

func _process(delta: float) -> void:
	if GameManager.get_chicken_count() >= GameManager.max_population:
		return
	spawn_timer += delta
	if spawn_timer >= GameManager.spawn_rate:
		spawn_timer = 0.0
		_spawn_chicken()

func _spawn_chicken() -> void:
	var chicken: Chicken = chicken_scene.instantiate()
	chicken.chicken_type = _get_random_chicken_type()
	chicken_container.add_child(chicken)
	chicken.position = _get_spawn_position()
	GameManager.add_chicken()

func _get_random_chicken_type() -> ChickenType:
	var roll: float = randf()
	var cumulative: float = 0.0
	
	for id in GameManager.SPAWN_ORDER:
		cumulative += GameManager.get_chicken_spawn_chance(id)
		if roll < cumulative:
			return chicken_types[id]
	return chicken_types["basic"]

func _get_spawn_position() -> Vector2:
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.size.y)
	)
	return pos
