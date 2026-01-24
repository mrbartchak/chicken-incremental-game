extends Control

func _ready() -> void:
	GameState.wings_changed.connect(update_wing_count)
	GameState.chicken_count_changed.connect(update_chicken_count)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func update_wing_count(amount) -> void:
	$WingLabel.text = str(amount)

func update_chicken_count(amount) -> void:
	$ChickenCount.text = str(amount)
