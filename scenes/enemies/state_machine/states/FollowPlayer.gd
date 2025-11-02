extends State

class_name FollowPlayer

@onready var enemy: Enemy = get_parent().get_parent()
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: State

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	state_duration -= delta
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, next_state)
	if animation:
		enemy.animations.play(animation)

func Physics_Update(_delta: float) -> void:
	enemy.nav.target_position = GlobalVariables.player_position
	if enemy.nav.is_navigation_finished():
		return
	var next_position = enemy.nav.get_next_path_position()
	enemy.direction = (next_position - enemy.global_position).normalized()
