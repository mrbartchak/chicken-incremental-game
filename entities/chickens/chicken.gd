class_name Chicken
extends Area2D

@export var wing_scene: PackedScene

var max_health: int = 2
var health: int
var dead: bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var walk_particles: GPUParticles2D = $WalkParticles
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _ready() -> void:
	state_machine.init(self, sprite)
	health = max_health

#func _unhandled_input(event: InputEvent) -> void:
	#state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

# ===================
#       Damage
# ===================
func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	if health <= 0:
		die()
		return
	flash()
	hit_particles.restart()

func flash() -> void:
	var flash_time: float = 0.05
	sprite.modulate = Color.ORANGE_RED
	await get_tree().create_timer(flash_time).timeout
	sprite.modulate = Color(1, 1, 1)

func die() -> void:
	if dead:
		return
	dead = true
	sprite.visible = false
	monitorable = false
	death_sound.pitch_scale = randf_range(0.9, 1.2)
	death_sound.play()
	drop_wing()
	death_particles.restart()
	await get_tree().create_timer(death_particles.lifetime).timeout
	queue_free()

# ===================
#        Drops
# ===================
func drop_wing() -> void:
	var wing: Area2D = wing_scene.instantiate()
	wing.global_position = global_position
	get_parent().add_child(wing)
