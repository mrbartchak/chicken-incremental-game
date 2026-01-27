extends Node

var camera: CustomCamera
var damage_number_scene := preload("res://ui/game/damage_label.tscn")

func _ready() -> void:
	Engine.time_scale = 1.0

# ================
#    Hit Freeze
# ================
func frame_freeze(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await  get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0

# ================
#   Screen Shake
# ================
func shake_screen(intensity: int, time: float) -> void:
	if camera:
		camera.screen_shake(intensity, time)

# ================
#   Damage Nums
# ================
func show_damage_at(amount: int, pos: Vector2) -> void:
	pass
