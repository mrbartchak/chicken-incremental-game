extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)

signal max_population_changed(amount: int)
signal spawn_rate_changed(amount: float)
signal upgrade_purchased()
signal attack_speed_changed(speed: float)
signal attack_radius_changed(radius: int)

const BASE_STARTING_WINGS: int = 0
const BASE_SPAWN_INTERVAL: float = 2.0
const BASE_MAX_POPULATION: int = 1
const BASE_WING_VALUE: int = 1
const BASE_DOUBLE_DROP_RATE: float = 0.0
const BASE_ATTACK_SPEED: float = 1.0
const BASE_ATTACK_RADIUS: int = 7

var _state: GameState
#=== Wings ===

var total_wings_collected: int = 0
var wing_value: int = BASE_WING_VALUE
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

#=== Upgrades ===
var upgrade_tracks: Dictionary = {}

func _ready() -> void:
	_state = GameState.new()
	_load_upgrade_tracks()

# ======== Queries ========
func get_wings() -> int:
	return _state.wings
# ======== Actions ========
func add_wings(amount: int) -> void:
	_state.wings += amount
	_state.total_wings_collected += amount
	wings_changed.emit(_state.wings)

func remove_wings(amount: int) -> void:
	_state.wings -= amount
	wings_changed.emit(_state.wings)

func add_chicken(amount: int = 1) -> void:
	_state.chicken_count += amount
	chicken_count_changed.emit(_state.chicken_count)

func remove_chicken(amount: int = 1) -> void:
	_state.chicken_count -= amount
	chicken_count_changed.emit(_state.chicken_count)

func _load_upgrade_tracks() -> void:
	var track1: UpgradeTrack = load("res://systems/upgrades/wing_value/wing_value_upgrade_track.tres")
	var track2: UpgradeTrack = load("res://systems/upgrades/max_population/max_population_upgrade_track.tres")
	var track3: UpgradeTrack = load("res://systems/upgrades/spawn_rate/spawn_rate_upgrade_track.tres")
	var track4: UpgradeTrack = load("res://systems/upgrades/attack_speed/attack_speed_upgrade_track.tres")
	upgrade_tracks[track1.id] = track1
	upgrade_tracks[track2.id] = track2
	upgrade_tracks[track3.id] = track3
	upgrade_tracks[track4.id] = track4

func can_afford(cost: int) -> bool:
	return get_wings() >= cost

func get_upgrade_track(track_id: String) -> UpgradeTrack:
	return upgrade_tracks.get(track_id)

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
	
