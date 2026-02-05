class_name MaxPopulationUpgrade
extends Upgrade

@export var population_increase: int

func apply() -> void:
	GameState.max_population += population_increase
