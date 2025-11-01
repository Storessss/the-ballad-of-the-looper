extends Node2D

@onready var tilemap: TileMapLayer = $Tilemap

func _ready() -> void:
	GlobalVariables.tilemap = tilemap
	GlobalVariables.right = 1280
	GlobalVariables.bottom = 720
	for cell in tilemap.get_used_cells():
		#if tilemap.get_cell_source_id(cell) == 7:
		GlobalVariables.tilemap.map.append(cell)
	MusicPlayer.change_music(preload("res://music/DUNGEON KILLER.ogg"))
