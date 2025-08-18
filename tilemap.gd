extends TileMapLayer

#var tileset = preload("res://sprites/tileset_dungeon_test.png")
#
#func swap_tiles():
	#tile_set.get_source(0).texture = new_tileset
#
##func _ready():
	##swap_tiles()
#
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("attack"):
		#swap_tiles()
func set_floor(cell: Vector2i):
	set_cells_terrain_connect([cell], 0, -1)
	set_cell(cell, 7, Vector2i(0, 0), 0)
