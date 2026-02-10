class_name Hud
extends Control

@onready var top_bar: HBoxContainer = $HudMargin/TopBar
@onready var wing_count_label: Label = $HudMargin/TopBar/WingCount
@onready var shop: ShopMenu = $ShopMenu
@onready var ingame_settings: IngameSettings = $IngameSettings

func _ready() -> void:
	connect_signals()
	update_wing_count_label(GameManager.get_wings())

func connect_signals() -> void:
	GameManager.wings_changed.connect(update_wing_count_label)

# ================
#    Callbacks
# ================
func _on_settings_button_pressed() -> void:
	ingame_settings.open()

func _on_shop_button_pressed() -> void:
	shop.open()

func update_wing_count_label(amount: int) -> void:
	wing_count_label.text = str(amount)
	GameEffects.pop(top_bar)
