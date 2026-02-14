extends Control

var panels: Array[PanelContainer] = []

@onready var upgrades_button: TextureButton = %UpgradesButton
@onready var chickens_button: TextureButton = %ChickensButton
@onready var shop_button: TextureButton = %ShopButton
@onready var settings_button: TextureButton = %SettingsButton

func _ready() -> void:
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

func _show_panel(panel_to_show: PanelContainer) -> void:
	for panel in panels:
		panel.hide()
	
	panel_to_show.show()
