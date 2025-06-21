extends State

class_name Wait

@export var fsm: Node
@export var states_to_check: Array[State]
@export var no_active_state: State
@export var active_state: State

func Enter() -> void:
	for state: State in states_to_check:
		if fsm.current_state == state:
			Transitioned.emit(self, active_state)
	Transitioned.emit(self, no_active_state)
