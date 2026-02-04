class_name ShopMenu
extends CanvasLayer

@onready var wing_count_label: Label = $ShopPanel/ShopMargin/ShopMenuStack/TopBar/WingCount/WingLabel

func _ready() -> void:
	close()

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func _on_exit_button_pressed() -> void:
	close()
