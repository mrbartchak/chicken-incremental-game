class_name Hud
extends Control

@onready var top_bar: HBoxContainer = %TopBar
@onready var wing_count_label: Label = $HudMargin/HBoxContainer/GameplayOverlay/TopBar/WingCount

func _ready() -> void:
	connect_signals()
	update_wing_count_label()

func connect_signals() -> void:
	GameManager.wings_changed.connect(update_wing_count_label)

# ================
#    Callbacks
# ================

func update_wing_count_label() -> void:
	wing_count_label.text = str(GameManager.get_wings())
	GameEffects.pop(top_bar)
	%TotalWingsCollected.text = str(GameManager.get_total_wings_collected())
