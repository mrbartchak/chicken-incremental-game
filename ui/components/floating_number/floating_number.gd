class_name FloatingNumber
extends Label

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 20, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_delay(0.2)
	tween.chain().tween_callback(queue_free)

func set_value(value: int) -> void:
	text = "+" + str(value)
	set_value_outline(value)

func set_color(color: Color) -> void:
	modulate = color

func set_value_outline(value: int) -> void:
	for child: Label in get_children():
		child.text = "+" + str(value)
