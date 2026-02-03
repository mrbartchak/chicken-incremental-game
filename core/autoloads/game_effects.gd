extends Node

var camera: CustomCamera
var floating_number_scene := preload("res://ui/shared/floating_number.tscn")

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
func spawn_floating_number(value: int, pos: Vector2, color: Color = Color.WHITE) -> void:
	var floating_number: FloatingNumber =  floating_number_scene.instantiate()
	floating_number.position = pos
	floating_number.set_value(value)
	floating_number.set_color(color)
	get_tree().current_scene.add_child(floating_number)

# ================
#      Pop
# ================
func pop(target: Control, amount: float = 1.2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target, "scale", Vector2(amount, amount), 0.1)
	tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.1)
