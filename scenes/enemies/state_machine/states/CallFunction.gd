extends State

class_name CallFunction

@onready var enemy: Enemy = get_parent().get_parent()
@export var function_name: String
@export var next_state: State

func Enter() -> void:
	enemy.call(function_name)
	Transitioned.emit(self, next_state)
