class_name Sword
extends Area2D

var follow_speed: float = 20.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var target := get_global_mouse_position()
	global_position = global_position.lerp(target, follow_speed * delta)

func attack() -> void:
	var bodies: Array[Area2D] = get_overlapping_areas()
	for area: Area2D in bodies:
		if area.has_method("take_damage"):
			area.take_damage(1)
