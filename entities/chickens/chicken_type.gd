class_name ChickenType
extends Resource

@export var id: String
@export var display_name: String
@export var sprite_frames: SpriteFrames
@export var badge_icon: Texture2D = load("res://ui/screens/side_panel/assets/locked_chicken_badge.png")
@export var speed: float = 50.0
@export var max_health: int = 1
@export var wing_type: WingType
@export var unlock_milestone: int
@export var spawn_weight: float
