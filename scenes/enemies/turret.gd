extends Enemy

@onready var pupil: Sprite2D = $Pupil
var pupil_direction: Vector2

func _process(delta: float) -> void:
	super._process(delta)
	pupil_direction = (GlobalVariables.player_position - global_position).normalized()
	if $FSM.current_state != $FSM/Idle:
		pupil.position = cast_point.position + pupil_direction * 0.7
	else:
		pupil.position = cast_point.position
