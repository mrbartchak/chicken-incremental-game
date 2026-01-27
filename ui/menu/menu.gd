extends Control

@onready var game_scene: PackedScene = preload("res://core/game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
