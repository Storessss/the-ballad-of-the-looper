extends Node2D

@onready var tilemap: TileMapLayer = $Tilemap
@export var music: AudioStream = preload("res://music/A Safe Place.ogg")

func _ready() -> void:
	GlobalVariables.tilemap = tilemap
	GlobalVariables.right = 426
	GlobalVariables.bottom = 240
	for cell in tilemap.get_used_cells():
		GlobalVariables.tilemap.map.append(cell)
	$Player.remove_child($Player.camera)
	MusicPlayer.change_music(music)
