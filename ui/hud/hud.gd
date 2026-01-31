class_name Hud
extends Control

@onready var wing_count_group: HBoxContainer = $MarginContainer/TopBar/RightGroup
@onready var wing_count_label: Label = $MarginContainer/TopBar/RightGroup/WingCount
@onready var shop: ShopMenu = $ShopMenu
@onready var ingame_settings: IngameSettings = $IngameSettings

func _ready() -> void:
	connect_signals()
	update_wing_count_label(GameState.wings)

func connect_signals() -> void:
	GameState.wings_changed.connect(update_wing_count_label)

# ================
#    Callbacks
# ================
func _on_settings_button_pressed() -> void:
	ingame_settings.open()

func _on_shop_button_pressed() -> void:
	shop.open()

func update_wing_count_label(amount: int) -> void:
	wing_count_label.text = str(amount)
	GameEffects.pop(wing_count_group)
