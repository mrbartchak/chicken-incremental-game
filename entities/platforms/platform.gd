extends Sprite2D

@export var float_height: float = 1.0
@export var float_speed: float = 1.0

var base_y: float

func _ready():
	base_y = position.y

func _process(_delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_height
