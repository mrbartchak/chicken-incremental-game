class_name UpgradeTrack
extends Resource

@export var id: String
@export var display_name: String
@export var upgrades: Array[Upgrade]

func get_upgrade_at(index: int) -> Upgrade:
	if index < 0 or index > upgrades.size():
		return null
	return upgrades[index]

func get_max_upgrades() -> int:
	return upgrades.size()
