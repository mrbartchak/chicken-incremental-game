extends Node

signal wings_changed()
signal chicken_count_changed(amount: int)
signal stats_changed()

const BASE_WING_VALUE_BONUS: int = 0
const BASE_MAX_POPULATION: int = 1
const BASE_SPAWN_RATE: float = 1.5
const BASE_ATTACK_SPEED: float = 1.0
const BASE_ATTACK_RADIUS: int = 8

var _state: GameState
var _upgrade_tracks: Dictionary = {}
var _chicken_types: Dictionary = {}
var _unlocked_chicken_types: Array[String] = []

# Computed Stats (derived from state)
var wing_value_bonus: int = BASE_WING_VALUE_BONUS
var max_population: int = BASE_MAX_POPULATION
var spawn_rate: float = BASE_SPAWN_RATE
var attack_speed: float = BASE_ATTACK_SPEED
var attack_radius: int = BASE_ATTACK_RADIUS

func _ready() -> void:
	if not _state:
		_state = GameState.new()
	_load_upgrade_tracks()
	_load_chicken_types()

# ============ Queries ============
func get_wings() -> int:
	return _state.wings

func get_total_wings_collected() -> int:
	return _state.total_wings_collected

func get_chicken_count() -> int:
	return _state.chicken_count

func get_upgrade_track(track_id: String) -> UpgradeTrack:
	return _upgrade_tracks.get(track_id)

func get_upgrade_progress(track_id: String) -> int:
	return _state.upgrade_progress.get(track_id, 0)

func get_next_upgrade(track_id: String) -> Upgrade:
	var track: UpgradeTrack = get_upgrade_track(track_id)
	if not track:
		return null
	return track.get_upgrade_at(get_upgrade_progress(track_id))

func is_track_complete(track_id: String) -> bool:
	var track: UpgradeTrack = get_upgrade_track(track_id)
	if not track:
		return true
	return get_upgrade_progress(track_id) >= track.get_max_upgrades()

func can_afford(cost: int) -> bool:
	return _state.wings >= cost

func can_afford_next_upgrade(track_id: String) -> bool:
	var upgrade: Upgrade = get_next_upgrade(track_id)
	if not upgrade:
		return false
	return can_afford(upgrade.cost)

func get_random_chicken_type() -> ChickenType:
	if _unlocked_chicken_types.is_empty():
		return null
	var total_weight: float = 0.0
	for type_id: String in _unlocked_chicken_types:
		var type: ChickenType = _chicken_types.get(type_id)
		total_weight += type.spawn_weight
	
	var roll: float = randf() * total_weight
	for type_id: String in _unlocked_chicken_types:
		var type: ChickenType = _chicken_types.get(type_id)
		roll -= type.spawn_weight
		if roll <= 0:
			return type
	
	return _chicken_types.get(_unlocked_chicken_types[-1])

# ============ Actions ============
func collect_wing(base_value: int, at: Vector2) -> void:
	var final_value: int = base_value + wing_value_bonus
	_state.wings += final_value
	_state.total_wings_collected += final_value
	GameEffects.spawn_floating_number(final_value, at)
	wings_changed.emit()
	_update_unlocked_chicken_types()

func spend_wings(amount: int) -> void:
	_state.wings = max(0, _state.wings - amount)
	wings_changed.emit()

func add_chicken(amount: int = 1) -> void:
	_state.chicken_count += amount
	chicken_count_changed.emit(_state.chicken_count)

func remove_chicken(amount: int = 1) -> void:
	_state.chicken_count -= amount
	chicken_count_changed.emit(_state.chicken_count)

func purchase_upgrade(track_id: String) -> bool:
	if is_track_complete(track_id):
		return false
	if not can_afford_next_upgrade(track_id):
		return false
	
	var upgrade: Upgrade = get_next_upgrade(track_id)
	spend_wings(upgrade.cost)
	_state.upgrade_progress[track_id] = get_upgrade_progress(track_id) + 1
	_recalculate_stats()
	stats_changed.emit()
	
	return true

# ============ State Management ============
func new_game() -> void:
	_state = GameState.new()
	_init_track_progress()
	_update_unlocked_chicken_types()
	_recalculate_stats()
	_emit_all()

func get_state_dict() -> Dictionary:
	return _state.to_dict()

func load_state_dict(data: Dictionary) -> void:
	_state = GameState.from_dict(data)
	_init_track_progress()
	_update_unlocked_chicken_types()
	_recalculate_stats()
	_emit_all()

# ============ Reducer ============
func _recalculate_stats() -> void:
	wing_value_bonus = BASE_WING_VALUE_BONUS
	max_population = BASE_MAX_POPULATION
	spawn_rate = BASE_SPAWN_RATE
	attack_speed = BASE_ATTACK_SPEED
	attack_radius = BASE_ATTACK_RADIUS
	
	for track_id: String in _upgrade_tracks:
		var track: UpgradeTrack = _upgrade_tracks[track_id]
		var progress: int = get_upgrade_progress(track_id)
		
		for i in range(progress):
			var upgrade: Upgrade = track.get_upgrade_at(i)
			if upgrade:
				_apply_upgrade_effect(upgrade)
	stats_changed.emit()

func _apply_upgrade_effect(upgrade: Upgrade) -> void:
	match upgrade.effect_type:
		"wing_value":
			wing_value_bonus += int(upgrade.effect_value)
		"max_population":
			max_population += int(upgrade.effect_value)
		"spawn_rate":
			spawn_rate -= upgrade.effect_value
		"attack_speed":
			attack_speed -= upgrade.effect_value
		"attack_radius":
			attack_radius += int(upgrade.effect_value)

# ============ Internal ============
func _emit_all() -> void:
	wings_changed.emit()
	chicken_count_changed.emit(_state.chicken_count)
	stats_changed.emit()

func _load_upgrade_tracks() -> void:
	var tracks: Array = [
		load("res://systems/upgrades/wing_value/wing_value_upgrade_track.tres"),
		load("res://systems/upgrades/max_population/max_population_upgrade_track.tres"),
		load("res://systems/upgrades/spawn_rate/spawn_rate_upgrade_track.tres"),
		load("res://systems/upgrades/attack_speed/attack_speed_upgrade_track.tres"),
		load("res://systems/upgrades/attack_radius/attack_radius_upgrade_track.tres")
	]
	for track: UpgradeTrack in tracks:
		_upgrade_tracks[track.id] = track

func _init_track_progress() -> void:
	for track_id: String in _upgrade_tracks:
		if not _state.upgrade_progress.has(track_id):
			_state.upgrade_progress[track_id] = 0

func _load_chicken_types() -> void:
	var types: Array = [
		load("res://entities/chickens/types/basic_chicken.tres"),
		load("res://entities/chickens/types/silver_chicken.tres")
	]
	for type: ChickenType in types:
		_chicken_types[type.id] = type

func _update_unlocked_chicken_types() -> void:
	for type_id: String in _chicken_types:
		if type_id in _unlocked_chicken_types:
			continue
		var type: ChickenType = _chicken_types.get(type_id)
		if _state.total_wings_collected >= type.unlock_milestone:
			_unlocked_chicken_types.append(type_id)
