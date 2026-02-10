extends CanvasLayer

var follow_speed: float = 32.0
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	layer = 100

func _process(delta: float) -> void:
	var target: Vector2 = get_viewport().get_mouse_position()
	sprite.global_position = sprite.global_position.lerp(target, follow_speed * delta)

func show_cursor() -> void:
	sprite.visible = true

func hide_cursor() -> void:
	sprite.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		GameEffects.pop(sprite, 1.5)
