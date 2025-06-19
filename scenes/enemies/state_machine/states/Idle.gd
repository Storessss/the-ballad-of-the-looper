extends State

class_name Idle

@export var enemy: Enemy
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: String

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	enemy.direction = Vector2.ZERO
	if animation:
		enemy.animations.play(animation)
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, next_state)
