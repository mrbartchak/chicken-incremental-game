extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)
signal max_population_changed(amount: int)
signal spawn_rate_changed(amount: float)
signal upgrade_purchased()

#=== Wings ===
var wings: int = 100:
	set(value):
		wings = value
		wings_changed.emit(wings)

var total_wings_collected: int = 0
var wing_value: int = 1
#=== Chickens ===
var chicken_count: int = 0
var max_population: int = 1:
	set(value):
		max_population = value
		max_population_changed.emit(max_population)
var spawn_rate: float = 2.0:
	set(value):
		spawn_rate = value
		spawn_rate_changed.emit(spawn_rate)

#=== Upgrades ===
var upgrade_tracks: Dictionary = {}

func _ready() -> void:
	_load_upgrade_tracks()

func _load_upgrade_tracks() -> void:
	var track1: UpgradeTrack = load("res://upgrades/wing_value/wing_value_upgrade_track.tres")
	var track2: UpgradeTrack = load("res://upgrades/max_population/max_population_upgrade_track.tres")
	var track3: UpgradeTrack = load("res://upgrades/spawn_rate/spawn_rate_upgrade_track.tres")
	upgrade_tracks[track1.id] = track1
	upgrade_tracks[track2.id] = track2
	upgrade_tracks[track3.id] = track3

func can_afford(cost: int) -> bool:
	return wings >= cost

func collect_wing() -> void:
	wings += wing_value
	total_wings_collected += wing_value

func add_chickens(amount: int = 1) -> void:
	chicken_count += amount
	chicken_count_changed.emit(chicken_count)

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
	wings -= upgrade.cost
	track.increment_index()
	# add to purchased upgrades list
	upgrade.apply()
	upgrade_purchased.emit()
	
