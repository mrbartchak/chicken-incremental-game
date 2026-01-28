class_name MainMenu
extends Control

@onready var game_scene: PackedScene = preload("res://core/game.tscn")
@onready var version_label: Label = $VersionLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_version_label()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func update_version_label() -> void:
	version_label.text = Version.get_full_version()
