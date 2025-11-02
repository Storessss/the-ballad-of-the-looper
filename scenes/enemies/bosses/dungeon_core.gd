extends Enemy

@onready var pupil: Sprite2D = $AnimatedSprite2D/Pupil
var pupil_direction: Vector2

func _process(delta: float) -> void:
	super._process(delta)
	pupil_direction = (GlobalVariables.player_position - global_position).normalized()
	pupil.position = pupil_direction * 0.9
	if invincible:
		pupil.visible = false
	else:
		pupil.visible = true

func _exit_tree() -> void:
	MusicPlayer.change_music(preload("res://music/A Safe Place.ogg"))
