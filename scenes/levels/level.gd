extends Node2D

func _process(_delta: float) -> void:
	set_camera_limits()

func set_camera_limits() -> void:
	var map_limits = $Tilemap.get_used_rect()
	var map_cell_size = 16
	GlobalVariables.player.camera.limit_right = map_limits.end.x * map_cell_size
	GlobalVariables.player.camera.limit_bottom = map_limits.end.y * map_cell_size
