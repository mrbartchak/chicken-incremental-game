class_name SpawnRateUpgrade
extends Upgrade

@export var spawn_interval_decrease: float

func apply() -> void:
	GameManager.spawn_rate -= spawn_interval_decrease
