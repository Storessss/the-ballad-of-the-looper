extends Node

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var sound_players: Array[AudioStreamPlayer]

func _ready() -> void:
	music_player.bus = "Music"
	music_player.volume_db = -2
	add_child(music_player)
	change_music(preload("res://music/Of Days Long Past.ogg"))

func new_sound_player(db: int = 0) -> AudioStreamPlayer:
	var sound_player: AudioStreamPlayer = AudioStreamPlayer.new()
	sound_player.bus = "Sounds"
	sound_player.volume_db = db
	add_child(sound_player)
	sound_players.append(sound_player)
	return sound_player
	
func _process(_delta: float) -> void:
	for sound_player: AudioStreamPlayer in sound_players:
		if not sound_player.playing:
			sound_player.queue_free()
			sound_players.erase(sound_player)
			
func change_music(music: AudioStream):
	if music_player.stream != music:
		music_player.stream = music
		music_player.play()

func enemy_defeat() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-8)
	sound_player.stream = preload("res://sounds/enemy_defeat.wav")
	sound_player.play()
	return sound_player

func hit() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/hit.wav")
	sound_player.play()
	return sound_player

func enemy_hit() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-4)
	sound_player.stream = preload("res://sounds/enemy_hit.wav")
	sound_player.play()
	return sound_player

func boss_defeat() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-6)
	sound_player.stream = preload("res://sounds/boss_defeat.mp3")
	sound_player.play()
	music_player.stop()
	return sound_player

func boss_stagger() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/boss_stagger.mp3")
	sound_player.play()
	return sound_player

func bullet_deflect() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-18)
	sound_player.stream = preload("res://sounds/bullet_deflect.wav")
	sound_player.play()
	return sound_player

func text() -> AudioStreamPlayer:
	var sound_player = MusicPlayer.new_sound_player(-3)
	sound_player.stream = preload("res://sounds/text_sound.wav")
	sound_player.pitch_scale = randf_range(0.75, 0.9)
	sound_player.play()
	return sound_player

func explosion() -> AudioStreamPlayer:
	var sound_player = MusicPlayer.new_sound_player(-7)
	sound_player.stream = preload("res://sounds/explosion.wav")
	sound_player.play()
	return sound_player

func dim_get() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-6)
	sound_player.stream = preload("res://sounds/dim_get.wav")
	sound_player.pitch_scale = randf_range(0.9, 1.1)
	sound_player.play()
	return sound_player

func wall_break() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-5)
	sound_player.stream = preload("res://sounds/wall_break.mp3")
	sound_player.play()
	return sound_player

func weapon_break() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/weapon_break.mp3")
	sound_player.play()
	return sound_player

func item_throw() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/dash_sound.wav")
	sound_player.pitch_scale = 2.0
	sound_player.play()
	return sound_player

func item_get() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-4)
	sound_player.stream = preload("res://sounds/item_get.mp3")
	sound_player.play()
	return sound_player

func metal_hit() -> AudioStreamPlayer:
	var sound_player = new_sound_player(-3)
	sound_player.stream = preload("res://sounds/metal_hit.wav")
	sound_player.pitch_scale = 0.9
	sound_player.play()
	return sound_player

func potion_drink_finished() -> AudioStreamPlayer:
	var sound_player = new_sound_player(8)
	sound_player.stream = preload("res://sounds/potion_drink_finished.wav")
	sound_player.play()
	return sound_player

func shoot() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/shoot.wav")
	sound_player.play()
	return sound_player

func crush() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/crusher_crush.wav")
	sound_player.play()
	return sound_player

func beeping() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/beeping.mp3")
	sound_player.play()
	return sound_player

func heavy_shoot() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/shoot.wav")
	sound_player.pitch_scale = 0.87
	sound_player.play()
	return sound_player

func heavier_shoot() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/shoot.wav")
	sound_player.pitch_scale = 0.7
	sound_player.play()
	return sound_player

func radio_activate() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/radio_activate.wav")
	sound_player.play()
	return sound_player

func radio_deactivate() -> AudioStreamPlayer:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/radio_deactivate.wav")
	sound_player.play()
	return sound_player

func whispers() -> AudioStreamPlayer:
	var sound_player = new_sound_player(3)
	sound_player.stream = preload("res://sounds/whispers.mp3")
	sound_player.play()
	return sound_player
