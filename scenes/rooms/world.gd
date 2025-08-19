extends Node2D

@onready var tilemap = $Tilemap

var map_start := Vector2i(0, 0)
var map_size := Vector2i(101, 100)

var borders = Rect2(map_start.x, map_start.y, map_size.x, map_size.y)

func _ready() -> void:
	generate_level()
	
func generate_level():
	generate_borders()
	
	var walker := Walker.new(Vector2i(map_size.x / 2, map_size.y / 2), borders)
	var map: Array[Vector2i] = walker.walk(500, 2)
	walker.queue_free()
	tilemap.set_cells_terrain_connect(map, 0, -1)
	for location in map:
		tilemap.set_floor(location)
		
	generate_safe_room(map, tilemap)
		
	var enemy_count: int = 15
	var enemies: Array[PackedScene] = [
		preload("res://scenes/enemies/slime.tscn"),
		preload("res://scenes/enemies/spitter.tscn"),
		preload("res://scenes/enemies/crusher.tscn"),
		preload("res://scenes/enemies/triple_shooter.tscn"),
	]
	generate_enemies(map, enemy_count, enemies)
	#var bosses := [
		#preload("res://scenes/enemies/bosses/little_devil.tscn")
	#]
	#var boss = bosses.pick_random().instantiate()
	#boss.global_position = tilemap.map_to_local(map.pop_back())
	#add_child(boss)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().reload_current_scene()
		
func generate_borders() -> void:
	var border_size: Vector2 = Vector2(map_size.x * 16 - 1, map_size.y * 16 - 1)
	GlobalVariables.right = border_size.x
	GlobalVariables.bottom = border_size.y
	$WorldBorders/WorldBorderEnd.global_position = border_size
	var border_cells: Array[Vector2i]
	for i in range(map_size.x):
		for j in range(map_size.y):
			border_cells.append(Vector2i(map_start.x + i, map_start.y + j))
	tilemap.set_cells_terrain_connect(border_cells, 0, 0)
		
func generate_safe_room(map: Array[Vector2i], tilemap: TileMapLayer) -> void:
	var safe_pos: Vector2i
	while true:
		safe_pos = Vector2i(randi_range(map_start.x, map_start.x + map_size.x),
							randi_range(map_start.y, map_start.y + map_size.y))
		if not map.has(safe_pos):
			break

	for x in range(-1, 2):
		for y in range(-1, 2):
			var cell = safe_pos + Vector2i(x, y)
			tilemap.set_floor(cell)

	var nearest_floor: Vector2i = map[0]
	var min_distance := INF
	for cell in map:
		var distance = safe_pos.distance_to(cell)
		if distance < min_distance:
			min_distance = distance
			nearest_floor = cell
	
	var current_cell := safe_pos
	while current_cell != nearest_floor:
		if current_cell.x < nearest_floor.x: current_cell.x += 1
		elif current_cell.x > nearest_floor.x: current_cell.x -= 1
		elif current_cell.y < nearest_floor.y: current_cell.y += 1
		elif current_cell.y > nearest_floor.y: current_cell.y -= 1
		tilemap.set_floor(current_cell)

	$Player.global_position = tilemap.map_to_local(safe_pos)

func generate_enemies(map: Array[Vector2i], enemy_count: int, enemies: Array[PackedScene]) -> void:
	map.shuffle()
	for i in range(enemy_count):
		var location = map.pop_back()
		var enemy = enemies.pick_random().instantiate()
		enemy.global_position = tilemap.map_to_local(location)
		add_child(enemy)
