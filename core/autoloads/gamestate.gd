extends Node

signal wings_changed(amount: int)
signal chicken_count_changed(amount: int)

#=== Wings ===
var wings: int = 0
var total_wings_collected: int = 0
var wing_value: int = 1
#=== Chickens ===
var chicken_count: int = 0
var max_chickens: int = 1
#=== Upgrades ===
var upgrade_tracks: Dictionary = {}

func _ready() -> void:
	_load_upgrade_tracks()

func _load_upgrade_tracks() -> void:
	var track: UpgradeTrack = load("res://upgrades/wing_value/wing_value_upgrade_track.tres")
	upgrade_tracks[track.id] = track

func get_upgrade_track(track_id: String) -> UpgradeTrack:
	return upgrade_tracks.get(track_id)

func collect_wing() -> void:
	wings += wing_value
	total_wings_collected += wing_value
	wings_changed.emit(wings)

func add_chickens(amount: int = 1) -> void:
	chicken_count += amount
	chicken_count_changed.emit(chicken_count)
