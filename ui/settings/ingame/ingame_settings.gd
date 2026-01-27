class_name IngameSettings
extends Control

const MAIN_MENU: PackedScene = preload("res://ui/menu/main/main_menu.tscn")

func _ready() -> void:
	close()

func open() -> void:
	visible = true

func close() -> void:
	visible = false


func _on_resume_button_pressed() -> void:
	close()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
