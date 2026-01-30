class_name UpgradeTrackUI
extends VBoxContainer

@export var track_id: String

@onready var upgrade_icon: TextureRect = $CenterIcon/UpgradeIcon
@onready var cost_label: Label = $PurchaseButton/CostLabel

func _ready() -> void:
	GameState.upgrade_purchased.connect(_update_display)
	_update_display()

func _update_display() -> void:
	var track: UpgradeTrack = GameState.get_upgrade_track(track_id)
	if not track:
		return
	var upgrade: Upgrade = track.get_next_upgrade()
	if not upgrade:
		print("thats the max")
		return
	cost_label.text = str(upgrade.cost)
	upgrade_icon.texture = upgrade.icon

func _on_purchase_button_pressed() -> void:
	GameState.request_upgrade_purchase(track_id)
