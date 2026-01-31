class_name SpawnRateUpgrade
extends Upgrade

@export var spawn_interval_decrease: float

func apply() -> void:
	GameState.spawn_rate -= spawn_interval_decrease
