extends Enemy

@onready var pupil: Sprite2D = $AnimatedSprite2D/Pupil
var pupil_direction: Vector2

var small_explosion_scene: PackedScene = preload("res://scenes/bullets/small_explosion.tscn")

func _process(delta: float) -> void:
	super._process(delta)
	pupil_direction = (GlobalVariables.player_position - global_position).normalized()
	if (can_die and starting_cutscene_finished) or (starting_cutscene_look and not starting_cutscene_roar):
		pupil.position = pupil_direction * 0.9
	else:
		var angle = randf() * TAU
		var offset = Vector2(cos(angle), sin(angle))
		pupil.position = pupil_direction * 0.9 + offset * 0.2
	if not invincible or starting_cutscene_look or starting_cutscene_roar:
		pupil.visible = true
	else:
		pupil.visible = false

func die() -> void:
	if can_die:
		can_die = false
		for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.die()
		$FSM.queue_free()
		$FSM2.queue_free()
		$AnimatedSprite2D/Pupil.texture = preload("res://sprites/wide_pupil.png")
		var sound_player: AudioStreamPlayer = MusicPlayer.whispers()
		MusicPlayer.music_player.stop()
		for i in range(25):
			await get_tree().create_timer(randf_range(0.1, 0.6)).timeout
			var small_explosion: AreaDamage = small_explosion_scene.instantiate()
			var angle = randf() * TAU
			var distance = randf_range(1, 100)
			var offset = Vector2(cos(angle), sin(angle)) * distance
			small_explosion.global_position = global_position + offset
			get_tree().current_scene.call_deferred("add_child", small_explosion)
		sound_player.stop()
		can_die = true
		super.die()

func _exit_tree() -> void:
	MusicPlayer.change_music(preload("res://music/A Safe Place.ogg"))

var starting_cutscene_open_eye: bool
var starting_cutscene_look: bool
var starting_cutscene_roar: bool
var starting_cutscene_finished: bool
func _ready() -> void:
	invincible = true
	MusicPlayer.music_player.stop()
	super._ready()
	starting_cutscene_open_eye = true
	$AnimatedSprite2D.play("closed_eye")
	await get_tree().create_timer(2.5).timeout
	$AnimatedSprite2D.play("eye_open")
	await $AnimatedSprite2D.animation_looped
	$AnimatedSprite2D.play("opened_eye")
	await get_tree().create_timer(0.7).timeout
	$AnimatedSprite2D.play("blink")
	await $AnimatedSprite2D.animation_looped
	$AnimatedSprite2D.play("opened_eye")
	await get_tree().create_timer(0.7).timeout
	$AnimatedSprite2D.play("blink")
	await $AnimatedSprite2D.animation_looped
	$AnimatedSprite2D.play("opened_eye")
	await get_tree().create_timer(2.0).timeout
	$AnimatedSprite2D.play("empty_eye")
	starting_cutscene_open_eye = false
	starting_cutscene_look = true
	await get_tree().create_timer(1.2).timeout
	starting_cutscene_look = false
	starting_cutscene_roar = true
	$AnimatedSprite2D/Pupil.texture = preload("res://sprites/wide_pupil.png")
	await get_tree().create_timer(1.2).timeout
	MusicPlayer.dungeon_roar()
	await get_tree().create_timer(2.0).timeout
	GlobalVariables.shake_camera.emit(30.0, 0.8)
	# TODO: add detection to know if player is playing with controller or keyboard
	# So the controller doesn't vibrate if the player is playing with M&K
	Input.start_joy_vibration(0, 1.0, 1.0, 3.5)
	await get_tree().create_timer(5.0).timeout
	starting_cutscene_roar = false
	starting_cutscene_finished = true
	invincible = false
	$FSM.play_state($FSM/PickRandomNextState)
	$FSM2.play_state($FSM2/ShootBullet)
	$AnimatedSprite2D/Pupil.texture = preload("res://sprites/pupil.png")
	#MusicPlayer.change_music(preload("res://music/DUNGEON KILLER.ogg"))
	MusicPlayer.change_music(preload("res://music/Nuclear-Throne-OST：-The-Nuclear-Throne-Theme.ogg"))
