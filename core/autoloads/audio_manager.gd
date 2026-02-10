extends AudioStreamPlayer

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var music_menu: AudioStream = preload("res://core/audio/music/lofi-piano-fantasy-bgm-quotcastlequot-224759.mp3")
var sfx_button_click: AudioStream = preload("res://core/audio/sfx/ui_button_click.wav")
var sfx_button_hover: AudioStream = preload("res://core/audio/sfx/ui_button_hover.wav")
var sfx_item_collect: AudioStream = preload("res://core/audio/sfx/collect_item_drop.wav")
var sfx_chicken_death: AudioStream = preload("res://core/audio/sfx/poof-80161.wav")

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	
	play_music(music_menu)

func play_music(audio: AudioStream, volume: float = -20.0) -> void:
	music_player.stream = audio
	music_player.volume_db = volume
	music_player.play()

func play_sfx(audio: AudioStream, pitch_range: float = 0.0, volume: float = 0.0) -> void:
	sfx_player.pitch_scale = 1.0 if pitch_scale == 0.0 else randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	sfx_player.stream = audio
	sfx_player.volume_db = volume
	sfx_player.play()

# ============ UI ============
func play_button_click() -> void:
	play_sfx(sfx_button_click, 0.0, -10.0)

func play_button_hover() -> void:
	play_sfx(sfx_button_hover)

# ========= ENTITIES =========
func play_item_collect() -> void:
	play_sfx(sfx_item_collect, 0.25, -15.0)

func play_chicken_death() -> void:
	play_sfx(sfx_chicken_death, 0.15, -10.0)
