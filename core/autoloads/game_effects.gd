extends Node

var _camera: CustomCamera
var _floating_number_scene := preload("res://ui/components/floating_number/floating_number.tscn")

func _ready() -> void:
	Engine.time_scale = 1.0

# ================
#  Camera Effects
# ================
func register_camera(camera: Camera2D) -> void:
	if not _camera:
		_camera = camera

func frame_freeze(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await  get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0

func shake_screen(intensity: int, time: float) -> void:
	if _camera:
		_camera.screen_shake(intensity, time)

# ================
#   Damage Nums
# ================
func spawn_floating_number(value: int, pos: Vector2, color: Color = Color.WHITE) -> void:
	var floating_number: FloatingNumber =  _floating_number_scene.instantiate()
	floating_number.position = pos
	floating_number.set_value(value)
	floating_number.set_color(color)
	get_tree().current_scene.add_child(floating_number)

# ================
#      Pops
# ================
func pop(target: CanvasItem, amount: float = 1.2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(target, "scale", Vector2(amount, amount), 0.1)
	tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.1)

func scale_in(target: Control, amount: float = 1.1, duration: float = 0.15) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "scale", Vector2(amount, amount), duration)

func scale_out(target: Control, duration: float = 0.15) -> void:
	scale_in(target, 1.0, duration)
