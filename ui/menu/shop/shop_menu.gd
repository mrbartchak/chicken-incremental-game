class_name ShopMenu
extends CanvasLayer

func _ready() -> void:
	close()

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func _on_exit_button_pressed() -> void:
	close()
