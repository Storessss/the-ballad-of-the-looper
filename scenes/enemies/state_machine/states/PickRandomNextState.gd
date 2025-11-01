extends State

class_name PickRandomNextState

#@onready var enemy: Enemy = get_parent().get_parent()
@export var states: Array[State]

func Update(_delta: float) -> void:
	Transitioned.emit(self, states.pick_random())
