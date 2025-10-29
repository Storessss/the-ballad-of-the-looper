extends State

class_name PlayAnimation

@onready var enemy: Enemy = get_parent().get_parent()
@export var animation: String
@export var final_frame: int
@export var sound: String
@export var aim_line: Line2D
@export var next_state: State
var sound_player: AudioStreamPlayer

func Enter() -> void:
	enemy.animations.play(animation)
	if sound:
		sound_player = MusicPlayer.call(sound)
	if aim_line:
		aim_line.visible = true

func Update(_delta: float) -> void:
	if enemy.animations.frame == final_frame:
		Transitioned.emit(self, next_state)

func Exit() -> void:
	if sound_player:
		sound_player.stop()
	if aim_line:
		aim_line.visible = false
		
func _exit_tree() -> void:
	if sound_player:
		sound_player.stop()
