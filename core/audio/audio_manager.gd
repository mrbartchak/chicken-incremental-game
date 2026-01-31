extends AudioStreamPlayer

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	play_music(load("res://core/audio/lofi-piano-fantasy-bgm-quotcastlequot-224759.mp3"))

func play_music(audio: AudioStream, volume: float = -10.0) -> void:
	music_player.stream = audio
	music_player.volume_db = volume
	music_player.play()
