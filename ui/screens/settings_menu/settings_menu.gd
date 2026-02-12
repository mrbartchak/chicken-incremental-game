extends Control



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/screens/main_menu/main_menu.tscn")


func _on_delete_save_button_pressed() -> void:
	SaveManager.delete_save()


func _on_playground_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playground.tscn")
