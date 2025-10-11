extends State

class_name PickRandomNextState

#@onready var enemy: Enemy = get_parent().get_parent()
@export var states: Array[State]

var passed: bool = true

func Enter() -> void:
	Transitioned.emit(self, states.pick_random())
