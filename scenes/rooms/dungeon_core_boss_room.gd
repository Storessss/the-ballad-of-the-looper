extends Node2D

@onready var tilemap: TileMapLayer = $Tilemap

func _ready() -> void:
	GlobalVariables.tilemap = tilemap
	GlobalVariables.right = 1280
	GlobalVariables.bottom = 720
	for cell in tilemap.get_used_cells():
		GlobalVariables.tilemap.map.append(cell)
