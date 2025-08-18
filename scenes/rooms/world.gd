extends Node2D

@onready var tilemap = $Tilemap

var map_start := Vector2i(-50, -50)
var map_size := Vector2i(100, 100)

var borders = Rect2(map_start.x, map_start.y, map_size.x, map_size.y)

func _ready() -> void:
	generate_level()
	
func generate_level():
	var border_cells: Array[Vector2i]
	for i in range(map_size.x):
		for j in range(map_size.y):
			border_cells.append(Vector2i(map_start.x + i, map_start.y + j))
	tilemap.set_cells_terrain_connect(border_cells, 0, 0)
	
	var walker := Walker.new(Vector2i(0, 0), borders)
	var map := walker.walk(500, 2)
	walker.queue_free()
	tilemap.set_cells_terrain_connect(map, 0, -1)
	for location in map:
		tilemap.set_cell(location, 7, Vector2i(0, 0), 0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().reload_current_scene()
