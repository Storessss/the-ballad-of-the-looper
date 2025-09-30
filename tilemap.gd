extends TileMapLayer

var new_walls: Texture = preload("res://sprites/dungeon_tileset2.png")
var new_floor: Texture = preload("res://sprites/dungeon_floor2.png")

func swap_tiles():
	tile_set.get_source(6).texture = new_walls
	tile_set.get_source(7).texture = new_floor

func _ready():
	swap_tiles()
	pass
		
var map: Array[Vector2i]
		
func set_floor(cell: Vector2i):
	set_cells_terrain_connect([cell], 0, -1)
	set_cell(cell, 7, Vector2i(0, 0), 0)
	if cell not in map:
		map.append(cell)
		return true
	return false
