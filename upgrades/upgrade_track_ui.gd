class_name UpgradeTrackUI
extends VBoxContainer

@export var track_id: String

@onready var upgrade_icon: TextureRect = $CenterIcon/UpgradeIcon
@onready var cost_label: Label = $BuyButton/CostLabel

func _ready() -> void:
	_update_display()

func _update_display() -> void:
	var track: UpgradeTrack = GameState.get_upgrade_track(track_id)
	if not track:
		return
	var upgrade: Upgrade = track.get_next_upgrade()
	cost_label.text = str(upgrade.cost)
	upgrade_icon.texture = upgrade.icon
