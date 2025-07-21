extends Node

var music_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var sound_players: Array

func _ready() -> void:
	music_player.bus = "Music"
	music_player.volume_db = -8
	music_player.max_distance = 999999999
	music_player.attenuation = 0
	add_child(music_player)
	change_music(preload("res://music/Blinded By Fight And Greed.ogg"))

func new_sound_player(db: int = 0) -> AudioStreamPlayer2D:
	var sound_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sound_player.bus = "Sounds"
	sound_player.volume_db = db
	sound_player.max_distance = 999999999
	sound_player.attenuation = 0
	add_child(sound_player)
	sound_players.append(sound_player)
	return sound_player
	
func _process(_delta: float) -> void:
	for player: AudioStreamPlayer2D in sound_players:
		if not player.playing:
			player.queue_free()
			sound_players.erase(player)
			
func change_music(music: AudioStream):
	if music_player.stream != music:
		music_player.stream = music
		music_player.play()

func enemy_defeat() -> void:
	var sound_player = new_sound_player(-5)
	sound_player.stream = preload("res://sounds/enemy_defeat.wav")
	sound_player.play()

func hit() -> void:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/hit.wav")
	sound_player.play()
	
func enemy_hit() -> void:
	var sound_player = new_sound_player(-4)
	sound_player.stream = preload("res://sounds/enemy_hit.wav")
	sound_player.play()
	
func boss_defeat() -> void:
	var sound_player = new_sound_player(-6)
	sound_player.stream = preload("res://sounds/boss_defeat.mp3")
	sound_player.play()
	music_player.stop()
	
func boss_stagger() -> void:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/boss_stagger.mp3")
	sound_player.play()
	
func bullet_deflect() -> void:
	var sound_player = new_sound_player(-18)
	sound_player.stream = preload("res://sounds/bullet_deflect.wav")
	sound_player.play()
	
func text_sound() -> void:
	var sound_player = MusicPlayer.new_sound_player(-3)
	sound_player.stream = preload("res://sounds/text_sound6.wav")
	sound_player.pitch_scale = randf_range(0.75, 0.9)
	sound_player.play()
