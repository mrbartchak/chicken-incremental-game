class_name ChickenRoaming
extends State

@export var idle_state: State
var roam_radius := 20.0
var speed := 20.0

var target_position: Vector2

func enter() -> void:
	var chicken: Chicken = entity as Chicken
	chicken.walk_particles.emitting = true
	
	var center := entity.global_position
	var angle := randf() * TAU
	var radius := randf() * roam_radius
	target_position = center + Vector2(
		cos(angle),
		sin(angle)
	) * radius
	target_position = clamp_to_screen(target_position)
	#warning: this is bad
	var dir = target_position - entity.global_position
	if dir.x > 0:
		animations.play("walk_right")
	elif dir.x < 0:
		animations.play("walk_left")

func process_physics(delta: float) -> State:
	var to_target: Vector2 = target_position - entity.global_position
	var distance: float = to_target.length()

	if distance < 0.2:
		entity.global_position = target_position
		return idle_state

	var direction: Vector2 = to_target.normalized()
	entity.global_position += direction * speed * delta
	return null

func exit() -> void:
	var chicken: Chicken = entity as Chicken
	chicken.walk_particles.emitting = false

func clamp_to_screen(pos: Vector2) -> Vector2:
	var base_margin: float = 8.0
	var bottom_margin: float = 8.0
	var viewport_rect = entity.get_viewport_rect()
	pos.x = clamp(pos.x, base_margin, viewport_rect.size.x - base_margin)
	pos.y = clamp(pos.y, base_margin, viewport_rect.size.y - base_margin - bottom_margin)
	return pos
