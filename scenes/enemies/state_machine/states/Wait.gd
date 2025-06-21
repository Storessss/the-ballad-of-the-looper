extends State

class_name Wait2

@export var state_duration_min: float
@export var state_duration_max: float
@export var next_state: State

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, next_state)
