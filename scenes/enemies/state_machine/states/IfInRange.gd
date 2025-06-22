extends State

class_name IfInRange

@onready var enemy: Enemy = get_parent().get_parent()
@export var trigger_distance: int
@export var exit_distance: int
@export var next_state: State
@export var exit_state: State

var in_range: bool

func Enter() -> void:
	if in_range:
		if enemy.global_position.distance_to(GlobalVariables.player_position) >= exit_distance:
			in_range = false
	else:
		if enemy.global_position.distance_to(GlobalVariables.player_position) <= trigger_distance:
			in_range = true
			
	if in_range:
		Transitioned.emit(self, next_state)
	else:
		Transitioned.emit(self, exit_state)
