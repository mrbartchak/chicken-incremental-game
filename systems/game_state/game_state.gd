class_name GameState
extends RefCounted

var wings: int = 0
var total_wings_collected: int = 0
var chicken_count: int = 0

func to_dict() -> Dictionary:
	return {
		"wings": wings,
		"total_wings_collected": total_wings_collected,
		"chicken_count": chicken_count
	}

static func from_dict(data: Dictionary) -> GameState:
	var state: GameState = GameState.new()
	state.wings = data.get("wings", 0)
	state.total_wings_collected = data.get("total_wings_collected", 0)
	state.chicken_count = data.get("chicken_count", 0)
	return state
