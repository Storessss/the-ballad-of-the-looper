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
		
var cells_to_set: Array[Vector2i]

func set_floor(cell: Vector2i, set_remaining: bool = false):
	cells_to_set.append(cell)
	if cells_to_set.size() > 250 or set_remaining:
		set_cells_terrain_connect(cells_to_set, 0, -1)
		for cell_to_set in cells_to_set:
			set_cell(cell_to_set, 7, Vector2i(0, 0), 0)
		cells_to_set.clear()

func set_floor_at_runtime(cell: Vector2i):
	if cell not in map:
		set_cells_terrain_connect([cell], 0, -1)
		set_cell(cell, 7, Vector2i(0, 0), 0)
		map.append(cell)
		return true
	return false
