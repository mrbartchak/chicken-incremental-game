extends Node

var camera: CustomCamera
var damage_number_scene := preload("res://ui/shared/damage_label.tscn")

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

# ================
#      Pop
# ================
func pop(target: Control, amount: float = 1.2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target, "scale", Vector2(amount, amount), 0.1)
	tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.1)
