class_name Spawner
extends Node

@export var entity_scene: PackedScene
@export var entity_container: Node2D
@export var spawn_area: Rect2 = Rect2(0, 0, 320, 180)
@export var max_entities: int = 1
@export var spawn_interval: float = 5.0

var spawn_timer: float = 0.0

func _ready() -> void:
	spawn_timer = 0.0
	max_entities = GameState.max_population
	spawn_interval = GameState.spawn_rate
	GameState.max_population_changed.connect(_update_max_population)
	GameState.spawn_rate_changed.connect(_update_spawn_rate)

func _process(delta: float) -> void:
	if get_active_entities() >= max_entities:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_interval:  #and get_active_entities() < max_entities:
		spawn_timer = 0.0
		spawn_entity()

func _update_max_population(amount: int) -> void:
	max_entities = amount

func _update_spawn_rate(amount: float) -> void:
	spawn_interval = amount

func spawn_entity() -> void:
	if not entity_scene or not entity_container:
		return
	var entity = entity_scene.instantiate() as Node2D
	entity_container.add_child(entity)
	entity.position = get_spawn_position()

func get_spawn_position() -> Vector2:
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.size.y)
	)
	return pos

func get_active_entities() -> int:
	var active_entities: int = 0
	for entity: Node2D in entity_container.get_children():
		if entity.is_in_group("chickens"):
			active_entities += 1
	return active_entities
