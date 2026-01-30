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
	pop(wing_count_group)

# ================
#     Effects
# ================
func pop(target: Control):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.1)
