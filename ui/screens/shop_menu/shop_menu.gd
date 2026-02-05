class_name ShopMenu
extends CanvasLayer

@onready var wing_count_label: Label = $ShopPanel/ShopMargin/ShopMenuStack/TopBar/WingCount/WingLabel
@onready var exit_button: TextureButton = $ShopPanel/ShopMargin/ShopMenuStack/TopBar/ExitButton

func _ready() -> void:
	GameState.upgrade_purchased.connect(_update_wing_count)
	_connect_signals()
	close()

func open() -> void:
	_update_wing_count()
	visible = true

func close() -> void:
	visible = false

func _connect_signals() -> void:
	exit_button.pressed.connect(close)
	exit_button.mouse_entered.connect(func():
		AudioManager.play_button_hover()
		GameEffects.scale_in(exit_button)
	)
	exit_button.mouse_exited.connect(func():
		AudioManager.play_button_hover()
		GameEffects.scale_out(exit_button)
	)

func _update_wing_count() -> void:
	wing_count_label.text = str(GameState.wings)
