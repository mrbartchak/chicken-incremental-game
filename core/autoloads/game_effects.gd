extends Node

var camera: Camera2D

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
var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = 5.0
var shake_time: float = 0.0
var shake_time_speed: float = 20.0
var noise = FastNoiseLite.new()
