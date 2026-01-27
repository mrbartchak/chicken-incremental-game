class_name Hud
extends Control

@onready var wing_count_label: Label = $MarginContainer/TopBar/RightGroup/WingCount
@onready var shop: ShopMenu = $ShopMenu

func _ready() -> void:
	connect_signals()

func _on_settings_button_pressed() -> void:
	get_tree().quit()

func _on_shop_button_pressed() -> void:
	shop.open()

func connect_signals() -> void:
	GameState.wings_changed.connect(update_wing_count_label)
	

func update_wing_count_label(amount: int) -> void:
	wing_count_label.text = str(amount)
