class_name Chicken
extends Area2D

enum State { IDLE, ROAMING }

@export var wing_scene: PackedScene

#var state: State = State.IDLE
var chicken_type: ChickenType
var health: int
var dead: bool = false

@onready var state_machine: StateMachine = $StateMachine

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var walk_particles: GPUParticles2D = $WalkParticles
@onready var death_particles: GPUParticles2D = $DeathParticles

func _ready() -> void:
	sprite.sprite_frames = chicken_type.sprite_frames
	state_machine.init(self, sprite)
	health = chicken_type.max_health
	play_spawn_animation()
	#GameManager.add_chicken(1)

#func _unhandled_input(event: InputEvent) -> void:
	#state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	$Sprite/HealthBar.value = health / float(chicken_type.max_health)
	state_machine.process_frame(delta)

# ===================
#       Damage
# ===================
func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	#GameEffects.frame_freeze(0.1, .05)
	if health <= 0:
		die() #call_deferred("die") !!!
		return
	flash()
	hit_particles.restart()


func die() -> void:
	if dead:
		return
	dead = true
	GameEffects.shake_screen(1, 0.2)
	sprite.visible = false
	monitorable = false
	AudioManager.play_chicken_death()
	drop_wing()
	death_particles.restart()
	await get_tree().create_timer(death_particles.lifetime).timeout
	GameManager.remove_chicken()
	queue_free()

# ===================
#        Drops
# ===================
func drop_wing() -> void:
	var wing: Wing = wing_scene.instantiate()
	wing.wing_type = chicken_type.wing_type
	wing.global_position = global_position
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
