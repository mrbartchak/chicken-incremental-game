extends Control

@onready var wing_count_label: Label = $MarginContainer/HSplitContainer/HBoxContainer/WingCountLabel

func _ready() -> void:
	connect_signals()

func _on_settings_button_pressed() -> void:
	get_tree().quit()

func connect_signals() -> void:
	GameState.wings_changed.connect(update_wing_count_label)

func update_wing_count_label(amount: int) -> void:
	wing_count_label.text = str(amount)
