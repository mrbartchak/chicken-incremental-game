extends HBoxContainer

@export var chicken_type: ChickenType

@onready var badge: TextureRect = $Badge
@onready var label: Label = $Label

func _ready() -> void:
	if chicken_type:
		badge.texture = chicken_type.badge_icon
		label.text = chicken_type.display_name
