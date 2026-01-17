extends TileMapLayer

var new_walls: Array[Texture] = [
	preload("res://sprites/dungeon_tileset_gray.png"),
	preload("res://sprites/dungeon_tileset_brown.png"),
	preload("res://sprites/dungeon_tileset_purple.png"),
	preload("res://sprites/dungeon_tileset_abyss.png")
]
var new_floors: Array[Texture] = [
	preload("res://sprites/dungeon_floor_gray.png"),
	preload("res://sprites/dungeon_floor_brown.png"),
	preload("res://sprites/dungeon_floor_purple.png"),
	preload("res://sprites/dungeon_floor_abyss.png"),
]
var new_tiles_index: int

func change_tiles(new_tiles_index: int) -> void:
	tile_set.get_source(6).texture = new_walls[new_tiles_index]
	tile_set.get_source(7).texture = new_floors[new_tiles_index]

func _ready() -> void:
	change_tiles(0)
	if get_tree().current_scene.name != "ArtifactRoom":
		change_tiles(GlobalVariables.area_number)
	
var map: Array[Vector2i]
		
var cells_to_set: Array[Vector2i]

func set_floor(cell: Vector2i, set_remaining: bool = false) -> void:
	cells_to_set.append(cell)
	if cells_to_set.size() > 250 or set_remaining:
		set_cells_terrain_connect(cells_to_set, 0, -1)
		for cell_to_set in cells_to_set:
			set_cell(cell_to_set, 7, Vector2i(0, 0), 0)
		cells_to_set.clear()

func set_floor_at_runtime(cell: Vector2i) -> bool:
	if cell not in map:
		set_cells_terrain_connect([cell], 0, -1)
		set_cell(cell, 7, Vector2i(0, 0), 0)
		map.append(cell)
		return true
	return false
