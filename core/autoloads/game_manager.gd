extends Node

# =================================================================
const BASE_STARTING_WINGS: int = 0
const BASE_SPAWN_INTERVAL: float = 2.0
const BASE_MAX_POPULATION: int = 1
const BASE_DOUBLE_DROP_RATE: float = 0.0
const BASE_ATTACK_SPEED: float = 1.0
const BASE_ATTACK_RADIUS: int = 7

signal max_population_changed(amount: int)
signal spawn_rate_changed(amount: float)
signal upgrade_purchased()
signal attack_speed_changed(speed: float)
signal attack_radius_changed(radius: int)

# =================================================================
#=== Chickens ===
var max_population: int = BASE_MAX_POPULATION:
	set(value):
		max_population = value
		max_population_changed.emit(max_population)
var spawn_rate: float = BASE_SPAWN_INTERVAL:
	set(value):
		spawn_rate = value
		spawn_rate_changed.emit(spawn_rate)
#=== Sword ===
var attack_speed: float = BASE_ATTACK_SPEED:
	set(value):
		attack_speed = value
		attack_speed_changed.emit(attack_speed)
var attack_radius: float = BASE_ATTACK_RADIUS:
	set(value):
		attack_radius = value
		attack_radius_changed.emit(attack_radius)
# =================================================================
# ^^^ OLD





signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)
signal stats_changed()

const BASE_WING_VALUE: int = 1

var _state: GameState
var _upgrade_tracks: Dictionary = {}

# Computed Stats
var wing_value: int = BASE_WING_VALUE









func _ready() -> void:
	_load_upgrade_tracks()
	_state = GameState.new()
	_init_track_progress()

func _load_upgrade_tracks() -> void:
	var tracks: Array = [
		load("res://systems/upgrades/wing_value/wing_value_upgrade_track.tres"),
		load("res://systems/upgrades/max_population/max_population_upgrade_track.tres"),
		load("res://systems/upgrades/spawn_rate/spawn_rate_upgrade_track.tres"),
		load("res://systems/upgrades/attack_speed/attack_speed_upgrade_track.tres")
	]
	for track: UpgradeTrack in tracks:
		_upgrade_tracks[track.id] = track

func _init_track_progress() -> void:
	for track_id: String in _upgrade_tracks:
		if not _state.upgrade_progress.has(track_id):
			_state.upgrade_progress[track_id] = 0

# ============ Queries ============
func get_wings() -> int:
	return _state.wings

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

# ============ Actions ============
func add_wings(amount: int) -> void:
	_state.wings += amount
	_state.total_wings_collected += amount
	wings_changed.emit(_state.wings)

func remove_wings(amount: int) -> void:
	_state.wings = max(0, _state.wings - amount)
	wings_changed.emit(_state.wings)

func add_chicken(amount: int = 1) -> void:
	_state.chicken_count += amount
	chicken_count_changed.emit(_state.chicken_count)

func remove_chicken(amount: int = 1) -> void:
	_state.chicken_count -= amount
	chicken_count_changed.emit(_state.chicken_count)

# ============ Reducer ============
func _recalculate_stats() -> void:
	wing_value = BASE_WING_VALUE
	
	for track_id: String in _upgrade_tracks:
		var track: UpgradeTrack = _upgrade_tracks[track_id]
		var progress: int = get_upgrade_progress(track_id)
		
		for i in range(progress):
			var upgrade: Upgrade = track.get_upgrade_at(i)
			if upgrade:
				_apply_upgrade_effect(upgrade)

func _apply_upgrade_effect(upgrade: Upgrade) -> void:
	match upgrade.effect_type:
		"wing_value":
			wing_value += int(upgrade.effect_value)













func request_upgrade_purchase(track_id: String) -> void:
	#if doesnt exists -- return
	#if track is done -- return
	#if track was already purchased -- return
	#if cant afford -- return
	#if track not available -- return
	var track: UpgradeTrack = get_upgrade_track(track_id)
	if not track or track.is_complete():
		return
	var upgrade: Upgrade = track.get_next_upgrade()
	if not can_afford(upgrade.cost):
		return
	remove_wings(upgrade.cost)
	track.increment_index()
	# add to purchased upgrades list
	upgrade.apply()
	upgrade_purchased.emit()
	
