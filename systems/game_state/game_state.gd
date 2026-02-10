class_name GameState
extends RefCounted

var wings: int = 100000
var total_wings_collected: int = 0
var chicken_count: int = 0
var upgrade_progress: Dictionary = {}

func to_dict() -> Dictionary:
	return {
		"wings": wings,
		"total_wings_collected": total_wings_collected,
		"chicken_count": chicken_count,
		"upgrade_progress": upgrade_progress.duplicate()
	}

static func from_dict(data: Dictionary) -> GameState:
	var state: GameState = GameState.new()
	state.wings = data.get("wings", 0)
	state.total_wings_collected = data.get("total_wings_collected", 0)
	state.chicken_count = 0 #data.get("chicken_count", 0)
	state.upgrade_progress = data.get("upgrade_progress", {})
	return state
