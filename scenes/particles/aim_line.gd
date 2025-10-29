extends Line2D


func _process(delta: float) -> void:
	set_point_position(1, to_local(GlobalVariables.player_position))
