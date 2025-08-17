extends Node2D

@onready var tilemap = $Tilemap

var borders = Rect2(-50, -50, 100, 100)

func _ready() -> void:
	generate_level()
	
func generate_level():
	var walker := Walker.new(Vector2i(0, 0), borders)
	var map := walker.walk(1000)
	walker.queue_free()
	tilemap.set_cells_terrain_connect(map, 0, -1)
	for location in map:
		tilemap.set_cell(location, 7, Vector2i(0, 0), 0)
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		get_tree().reload_current_scene()
