extends State

class_name ChasePlayer

@onready var enemy: Enemy = get_parent().get_parent()
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: State
@export var exit_state: State

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)
	enemy.nav.target_position = enemy.last_seen_position

func Update(delta: float) -> void:
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, next_state)
	if animation:
		enemy.animations.play(animation)

func Physics_Update(_delta: float) -> void:
	if enemy.nav.is_navigation_finished():
		if enemy.line_of_sight(enemy.global_position, GlobalVariables.player_position):
			Transitioned.emit(self, next_state)
		else:
			Transitioned.emit(self, exit_state)
	else:
		enemy.nav.target_position = enemy.last_seen_position
		var next_position = enemy.nav.get_next_path_position()
		enemy.direction = (next_position - enemy.global_position).normalized()
