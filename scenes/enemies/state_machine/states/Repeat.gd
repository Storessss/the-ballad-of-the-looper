extends State

class_name Repeat

@export var repeat_for_min: int
@export var repeat_for_max: int
@export var state_duration_min: float
@export var state_duration_max: float
@export var repeat_state: State
@export var exit_state: State

var initialized: bool

var state_duration: float
var repeat_for: int

func Enter() -> void:
	if not initialized:
		initialized = true
		repeat_for = randi_range(repeat_for_min, repeat_for_max)
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	if state_duration > 0:
		state_duration -= delta
	else:
		repeat_for -= 1
		if (repeat_for + 1) <= 0:
			repeat_for = randi_range(repeat_for_min, repeat_for_max)
			Transitioned.emit(self, exit_state)
		else:
			Transitioned.emit(self, repeat_state)
