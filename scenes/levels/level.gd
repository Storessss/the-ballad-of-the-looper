extends Node2D

func _ready() -> void:
	set_camera_limits()

func set_camera_limits() -> void:
	var map_limits = $Tilemap.get_used_rect()
	var map_cell_size = 16
	var limit_right: int = map_limits.end.x * map_cell_size
	var limit_bottom: int = map_limits.end.y * map_cell_size
	GlobalVariables.right = limit_right
	GlobalVariables.bottom = limit_bottom
