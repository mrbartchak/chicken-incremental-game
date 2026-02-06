class_name MainMenu
extends Control

@onready var continue_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/ContinueButton
@onready var new_game_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/NewGameButton
@onready var settings_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/SettingsButton
@onready var exit_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/ExitButton
@onready var version_label: Label = $VersionLabel

func _ready() -> void:
	if SaveManager.has_save():
		continue_button.show()
		new_game_button.hide()
	else:
		continue_button.hide()
		new_game_button.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_connect_button_sounds()
	_update_version_label()

# ============ Buttons ============
func _on_continue_button_pressed() -> void:
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_new_game_button_pressed() -> void:
	GameManager.new_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/screens/settings_menu/settings_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

# ============ Internal ============
func _connect_button_sounds() -> void:
	new_game_button.mouse_entered.connect(AudioManager.play_button_hover)
	settings_button.mouse_entered.connect(AudioManager.play_button_hover)
	exit_button.mouse_entered.connect(AudioManager.play_button_hover)
	
	new_game_button.pressed.connect(AudioManager.play_button_click)
	settings_button.pressed.connect(AudioManager.play_button_click)
	exit_button.pressed.connect(AudioManager.play_button_click)

func _update_version_label() -> void:
	version_label.text = Version.get_full_version()
