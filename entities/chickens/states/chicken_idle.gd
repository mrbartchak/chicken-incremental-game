class_name ChickenIdle
extends State

@export var roaming_state: State

var wait_time: float = 0.0
var elapsed: float = 0.0

func enter() -> void:
	if animations.animation == "walking_right":
		animations.play("idle_right")
	elif animations.animation == "walking_left":
		animations.play("idle_left")
	else:
		animations.play("default")
	elapsed = 0.0
	wait_time = randf_range(0.5, 1.5)

func process_frame(delta: float) -> State:
	elapsed += delta
	if elapsed >= wait_time:
		return roaming_state
	return null
