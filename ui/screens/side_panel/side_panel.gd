extends Control

var panels: Array[PanelContainer] = []

@onready var upgrades_button: TextureButton = %UpgradesButton
@onready var chickens_button: TextureButton = %ChickensButton
@onready var shop_button: TextureButton = %ShopButton
@onready var settings_button: TextureButton = %SettingsButton

func _ready() -> void:
	_add_children_to_interactive_ui_group(self)
	panels = [
		%UpgradePanel,
		%ChickensPanel,
		%ShopPanel,
		%SettingsPanel
	]
	upgrades_button.pressed.connect(_show_panel.bind(panels[0]))
	chickens_button.pressed.connect(_show_panel.bind(panels[1]))
	shop_button.pressed.connect(_show_panel.bind(panels[2]))
	settings_button.pressed.connect(_show_panel.bind(panels[3]))
	
	_show_panel(panels[0])
	upgrades_button.grab_focus()
	
	_handle_settings()

func _show_panel(panel_to_show: PanelContainer) -> void:
	for panel in panels:
		panel.hide()
	
	panel_to_show.show()

func _handle_settings() -> void:
	var menu_button: Button = %MenuButton
	var quit_button: Button = %QuitButton
	menu_button.pressed.connect(func(): 
		SaveManager.save_game()
		get_tree().change_scene_to_file("res://ui/screens/main_menu/main_menu.tscn")
	)
	quit_button.pressed.connect(func():
		SaveManager.save_game()
		get_tree().quit()
	)

func _add_children_to_interactive_ui_group(node: Node) -> void:
	if node is Control:
		node.add_to_group("interactive_ui")
	for child in node.get_children():
		_add_children_to_interactive_ui_group(child)
