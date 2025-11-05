extends Enemy

@onready var pupil: Sprite2D = $AnimatedSprite2D/Pupil
var pupil_direction: Vector2

var small_explosion_scene: PackedScene = preload("res://scenes/bullets/small_explosion.tscn")

func _process(delta: float) -> void:
	super._process(delta)
	pupil_direction = (GlobalVariables.player_position - global_position).normalized()
	if can_die:
		pupil.position = pupil_direction * 0.9
	else:
		var angle = randf() * TAU
		var offset = Vector2(cos(angle), sin(angle))
		pupil.position = pupil_direction * 0.9 + offset * 0.2
	if invincible:
		pupil.visible = false
	else:
		pupil.visible = true

func die() -> void:
	if can_die:
		can_die = false
		for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.die()
		$FSM.queue_free()
		$FSM2.queue_free()
		$FSM3.queue_free()
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
