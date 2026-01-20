class_name ChickenRoaming
extends State

@export var idle_state: State
var roam_radius := 20.0
var speed := 20.0

var target_position: Vector2

func enter() -> void:
	var center := parent.global_position
	var angle := randf() * TAU
	var radius := randf() * roam_radius
	target_position = center + Vector2(
		cos(angle),
		sin(angle)
	) * radius

func process_physics(delta: float) -> State:
	var to_target: Vector2 = target_position - parent.global_position
	var distance: float = to_target.length()

	if distance < 0.2:
		parent.global_position = target_position
		return idle_state

	var direction: Vector2 = to_target.normalized()
	parent.global_position += direction * speed * delta
	return null
