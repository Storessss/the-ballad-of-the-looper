extends State

class_name IfPlayerSpotted

@onready var enemy: Enemy = get_parent().get_parent()
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: State
@export var exit_state: State

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	enemy.direction = Vector2.ZERO
	if animation:
		enemy.animations.play(animation)
	if enemy.line_of_sight(enemy.global_position, GlobalVariables.player_position):
		Transitioned.emit(self, next_state)
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, exit_state)
