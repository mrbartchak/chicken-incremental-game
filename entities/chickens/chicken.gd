class_name Chicken
extends Area2D

enum State { IDLE, ROAMING }

@export var wing_scene: PackedScene

var state: State = State.IDLE
var chicken_type: ChickenType
var health: int
var dead: bool = false

var roam_area: CollisionShape2D
var elapsed: float = 0.0
var wait_time: float = 0.0
var roam_radius: float = 20.0
var target_position: Vector2

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hit_particles: GPUParticles2D = $HitParticles

func _ready() -> void:
	sprite.sprite_frames = chicken_type.sprite_frames
	health = chicken_type.max_health
	play_spawn_animation()
	_enter_idle()

func _process(delta: float) -> void:
	$Sprite/HealthBar.value = health / float(chicken_type.max_health)
	match state:
		State.IDLE:
			_process_idle(delta)
		State.ROAMING:
			_process_roaming(delta)

# ================
#      STATES
# ================
func _enter_idle() -> void:
	state = State.IDLE
	if sprite.animation == "walk_right":
		sprite.play("idle_right")
	elif sprite.animation == "walk_left":
		sprite.play("idle_left")
	else:
		sprite.play("default")
	elapsed = 0.0
	wait_time = randf_range(0.75, 1.5)

func _process_idle(delta) -> void:
	elapsed += delta
	if elapsed >= wait_time:
		_enter_roaming()

func _enter_roaming() -> void:
	state = State.ROAMING
	var angle: float = randf() * TAU
	var radius: float = randf() * roam_radius
	target_position = position + Vector2(cos(angle), sin(angle)) * radius
	target_position = _clamp_to_arena(target_position)
	
	if target_position.x > position.x:
		sprite.play("walk_right")
	else:
		sprite.play("walk_left")

func _process_roaming(delta) -> void:
	var to_target: Vector2 = target_position - position
	var distance: float = to_target.length()
	
	if distance < 0.2:
		self.position = target_position
		_enter_idle()
		return
	
	position += to_target.normalized() * chicken_type.speed * delta

# ===================
#       Damage
# ===================
func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	flash()
	if health <= 0:
		die() #call_deferred("die") !!!
		return
	hit_particles.restart()


func die() -> void:
	if dead:
		return
	dead = true
	drop_wing()
	
	GameEffects.shake_screen(1, 0.2)
	sprite.visible = false
	monitorable = false
	AudioManager.play_chicken_death()
	hit_particles.restart()
	await get_tree().create_timer(hit_particles.lifetime).timeout
	
	GameManager.remove_chicken()
	queue_free()

# ===================
#        Drops
# ===================
func drop_wing() -> void:
	var wing: Wing = wing_scene.instantiate()
	wing.wing_type = chicken_type.wing_type
	wing.global_position = position
	get_parent().add_child(wing)

# ===================
#      Visuals
# ===================
func play_spawn_animation() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).from(Vector2(0, 0))

func flash() -> void:
	var flash_time: float = 0.05
	sprite.modulate = Color.ORANGE_RED
	await get_tree().create_timer(flash_time).timeout
	sprite.modulate = Color(1, 1, 1)

# ================
#      Other
# ================
#func clamp_to_arena(pos: Vector2) -> Vector2:
	#var margin_x: float = 44.0
	#var margin_y: float = 26
	#var bottom_margin: float = 6.0
	#var viewport_rect = self.get_viewport_rect()
	#pos.x = clamp(pos.x, margin_x, viewport_rect.size.x - margin_x)
	#pos.y = clamp(pos.y, margin_y, viewport_rect.size.y - margin_y - bottom_margin)
	#return pos

func _clamp_to_arena(pos: Vector2) -> Vector2:
	var shape = roam_area.shape as RectangleShape2D
	var extents = shape.size / 2
	#var pos = roam_area.global_position
	var min_arena: Vector2 = roam_area.position - Vector2(extents.x, extents.y)
	var max_arena: Vector2 = roam_area.position + Vector2(extents.x, extents.y)
	
	return Vector2(
		clamp(pos.x, min_arena.x, max_arena.x),
		clamp(pos.y, min_arena.y, max_arena.y)
	)

#func _get_random_roam_target() -> Vector2:
	#var shape = roam_area.shape as RectangleShape2D
	#var extents: Vector2 = shape.size / 2
	#return Vector2(
		#randf_range(-extents.x, extents.x),
		#randf_range(-extents.y, extents.y)
	#)
