class_name UpgradeTrackUI
extends VBoxContainer

@export var track_id: String
@export var tier_filled: Texture2D
@export var tier_empty: Texture2D

@onready var tier_container: HBoxContainer = $UpgradeTiers
@onready var upgrade_icon: TextureRect = $CenterIcon/UpgradeIcon
@onready var cost_label: Label = $PurchaseButton/CostLabel
@onready var purchase_button: TextureButton = $PurchaseButton
@onready var maxed_logo: TextureRect = $MaxedLogo

func _ready() -> void:
	GameManager.stats_changed.connect(_update_display)
	_init_purchase_button()
	_update_display()

func _init_purchase_button() -> void:
	purchase_button.pivot_offset = Vector2(15, 0)
	purchase_button.pressed.connect(func():
		GameManager.purchase_upgrade(track_id))
	
	purchase_button.mouse_entered.connect(func():
		GameEffects.scale_in(purchase_button)
		AudioManager.play_button_hover())
	
	purchase_button.mouse_exited.connect(func():
		GameEffects.scale_out(purchase_button)
		AudioManager.play_button_hover())

func _update_display() -> void:
	var track: UpgradeTrack = GameManager.get_upgrade_track(track_id)
	if not track:
		return
	upgrade_icon.texture = track.icon
	_update_tiers(GameManager.get_upgrade_progress(track_id))
	var upgrade: Upgrade = GameManager.get_next_upgrade(track_id)
	if not upgrade:
		purchase_button.visible = false
		maxed_logo.visible = true
		return
	cost_label.text = replace_zeros_with_o(str(upgrade.cost))

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

# for popping the newly purchased tier
#func _on_upgrade_purchased(purchased_track_id: String) -> void:
	#var animate = purchased_track_id == track_id
	#_update_display(animate)

func replace_zeros_with_o(text: String) -> String:
	return text.replace("0", "o")
