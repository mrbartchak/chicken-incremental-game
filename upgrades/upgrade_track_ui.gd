class_name UpgradeTrackUI
extends VBoxContainer

@export var track_id: String
@export var tier_filled: Texture2D
@export var tier_empty: Texture2D

@onready var tier_container: HBoxContainer = $UpgradeTiers
@onready var upgrade_icon: TextureRect = $CenterIcon/UpgradeIcon
@onready var cost_label: Label = $PurchaseButton/CostLabel

func _ready() -> void:
	GameState.upgrade_purchased.connect(_update_display)
	_update_display()

func _update_display() -> void:
	var track: UpgradeTrack = GameState.get_upgrade_track(track_id)
	if not track:
		return
	_update_tiers(track.next_index)
	var upgrade: Upgrade = track.get_next_upgrade()
	if not upgrade:
		print("thats the max")
		return
	cost_label.text = str(upgrade.cost)
	upgrade_icon.texture = upgrade.icon

#func _init_tiers(current_tier: int, total_tiers: int) -> void:
	#pass
	#for i in range(total_tiers):
		#var tier_icon: TextureRect = TextureRect.new()
		#
	##highlight <= current
	##blank the rest

func _update_tiers(next_tier: int) -> void:
	for tier: TextureRect in tier_container.get_children():
		tier.texture = tier_filled if tier.get_index() < next_tier else tier_empty

func _on_purchase_button_pressed() -> void:
	GameState.request_upgrade_purchase(track_id)

# for popping the newly purchased tier
#func _on_upgrade_purchased(purchased_track_id: String) -> void:
	#var animate = purchased_track_id == track_id
	#_update_display(animate)
