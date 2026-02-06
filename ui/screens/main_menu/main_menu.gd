class_name MainMenu
extends Control

@onready var start_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/NewGameButton
@onready var settings_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/SettingsButton
@onready var exit_button: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/MenuButtons/ExitButton
@onready var version_label: Label = $VersionLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_connect_button_sounds()
	update_version_label()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	if not SaveManager.load_game():
		GameManager.new_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func update_version_label() -> void:
	version_label.text = Version.get_full_version()

func _connect_button_sounds() -> void:
	start_button.mouse_entered.connect(AudioManager.play_button_hover)
	settings_button.mouse_entered.connect(AudioManager.play_button_hover)
	exit_button.mouse_entered.connect(AudioManager.play_button_hover)
	
	start_button.pressed.connect(AudioManager.play_button_click)
	settings_button.pressed.connect(AudioManager.play_button_click)
	exit_button.pressed.connect(AudioManager.play_button_click)
