class_name UpgradeTrack
extends Resource

@export var id: String
@export var display_name: String
@export var upgrades: Array[Upgrade]
@export var next_index: int = 0

func get_next_upgrade() -> Upgrade:
	if next_index >= upgrades.size():
		return null
	return upgrades.get(next_index)

func is_complete() -> bool:
	return next_index >= upgrades.size()

func increment_index() -> void:
	next_index += 1
