extends Node2D

@onready var tilemap = $Tilemap

var map_start: Vector2i = Vector2i(0, 0)
var map_size: Vector2i = Vector2i(86, 86)

var generation_progress: int

var borders = Rect2(map_start.x, map_start.y, map_size.x, map_size.y)

var map: Array[Vector2i]

var player_scene: PackedScene = preload("res://scenes/main/player.tscn")

var enemy_count: int = 15
var enemies: Dictionary = {
	preload("res://scenes/enemies/slime.tscn"): INF,
	preload("res://scenes/enemies/spitter.tscn"): INF,
	preload("res://scenes/enemies/crusher.tscn"): 2,
	preload("res://scenes/enemies/triple_shooter.tscn"): INF,
	preload("res://scenes/enemies/dungeon_flower.tscn"): 5,
	preload("res://scenes/enemies/spingling.tscn"): 3,
	preload("res://scenes/enemies/sniper.tscn"): 3,
	preload("res://scenes/enemies/gold_pot.tscn"): 1,
	preload("res://scenes/enemies/turret.tscn"): 2,
	preload("res://scenes/enemies/fire_imp.tscn"): 2,
}
var bosses := [
	preload("res://scenes/enemies/bosses/little_devil.tscn"),
	preload("res://scenes/enemies/bosses/spingus.tscn"),
]
var boss_spawn_percentage: int = 50
var can_spawn_boss: bool = true
var dictionary_map: Dictionary

var trapdoor_scene: PackedScene = preload("res://scenes/props/wooden_trapdoor.tscn")
var can_spawn_trapdoor: bool = true

var loading_tips: Array[String] = [
	"Beautiful [rainbow freq=1.5, sat=1.5, val=1.5]DISENGAGER[/rainbow]",
	"[rainbow freq=1.5, sat=1.5, val=1.5]THE DISENGAGER[/rainbow] is waiting.",
	"[rainbow freq=1.5, sat=1.5, val=1.5]THE DISENGAGER[/rainbow] definitely exists",
	"[color=red]Fear[/color] is the mind killer",
	"Beautiful [color=orange]Fire Staff[/color]",
	"Next room for sure",
	"The cat is in the bag",
	"And the bag is in the river",
	"[color=red]HORRIBLE[/color] [color=gray]Sword[/color]",
	"Don't listen to the [color=red]Shopkeeper[/color]",
	"Just keep going",
	"[shake]The Ballad of the Looper Never Stops.[/shake]",
	"Trust the [color=green]Thoughts[/color] ignore the [color=red]Mind[/color]",
	"[rainbow freq=1.5, sat=1.5, val=1.5]THE DISENGAGER[/rainbow] will fix everything",
	"Next room is room " + str(GlobalVariables.fight_room_index),
]

var chest_scene: PackedScene = preload("res://scenes/props/chest.tscn")

func _ready() -> void:
	if GlobalVariables.fight_room_index > 16:
		MusicPlayer.change_music(preload("res://music/Hall of Quitters.ogg"))
		loading_tips = ["Are you a Quitter?"]
	else:
		MusicPlayer.change_music(preload("res://music/Of Days Long Past.ogg"))
		
	#seed(25)
	GlobalVariables.tilemap = tilemap
	
	var border_size: Vector2 = Vector2(map_size.x * 16 - 1, map_size.y * 16 - 1)
	GlobalVariables.right = border_size.x
	GlobalVariables.bottom = border_size.y
	$WorldBorders/WorldBorderEnd.global_position = border_size
	
	$Loading/TipLabel.text = loading_tips.pick_random()
	

var x: int
var y: int
var i: int
var counter: int
var step_percentage: int = 20
@onready var progress_label: RichTextLabel = $Loading/ProgressLabel
var progress: int
var step_progress: float
var generated: int

var border_cells: Array[Vector2i]

var walker: Walker

var spawn_pos: Vector2i
var room_size = Vector2i(4, 4)
var nearest_floor: Vector2i
var min_distance: int = INF
var current_cell: Vector2i
var generation_quota: int

func _process(_delta: float) -> void:
	
	if generation_progress == 0:
		
		step_progress = float(y * map_size.x + x) / float(map_size.x * map_size.y) * step_percentage
		progress = generation_progress * step_percentage + step_progress
		progress_label.text = str(progress) + "%"
		
		generated = 0
		generation_quota = 250
		while generated < generation_quota and generation_progress == 0:
			border_cells.append(Vector2i(map_start.x + x, map_start.y + y))
			
			x += 1
			if x >= map_size.x:
				x = 0
				y += 1
				
			if y >= map_size.y:
				generation_progress += 1
				tilemap.set_cells_terrain_connect(border_cells, 0, 0)
				
				walker = Walker.new(Vector2i(map_size.x / 2, map_size.y / 2), borders)
				add_child(walker)
				walker.activate_walk(432, 2)
				
			generated += 1
			
	elif generation_progress == 1:
		if not walker.walk_active:
			tilemap.map = map.duplicate()
			walker.queue_free()
			tilemap.set_cells_terrain_connect(map, 0, -1)
			generation_progress += 1
			
	elif generation_progress == 2:
		
		step_progress = float(i) / float(map.size()) * step_percentage
		progress = generation_progress * step_percentage + step_progress
		progress_label.text = str(progress) + "%"
		
		generated = 0
		generation_quota = 250
		while generated < generation_quota and generation_progress == 2:
			if i < map.size():
				tilemap.set_floor(map[i])
				dictionary_map[map[i]] = null
				i += 1
			else:
				generation_progress += 1
				i = 0
		
				while true:
					spawn_pos = Vector2i(
						randi_range(map_start.x, map_start.x + map_size.x - room_size.x),
						randi_range(map_start.y, map_start.y + map_size.y - room_size.y)
					)
					if not map.has(spawn_pos):
						break
						
				for x in range(room_size.x):
					for y in range(room_size.y):
						var cell = spawn_pos + Vector2i(x, y)
						tilemap.set_floor(cell)
						
				nearest_floor = map[0]
				
			generated += 1
		
	elif generation_progress == 3:
		
		step_progress = float(i) / float(map.size() - 1) * step_percentage
		progress = step_percentage * generation_progress + step_progress
		progress_label.text = str(progress) + "%"
		
		generated = 0
		generation_quota = 3000
		while generated < generation_quota and generation_progress == 3:
			if i < map.size():
				var distance = spawn_pos.distance_to(map[i])
				if distance < min_distance:
					min_distance = distance
					nearest_floor = map[i]
				i += 1
			else:
				generation_progress += 1
				current_cell = spawn_pos
				
			generated += 1
			
	elif generation_progress == 4:
		
		var total_distance = nearest_floor.distance_to(spawn_pos)
		var remaining_distance = current_cell.distance_to(nearest_floor)
		step_progress = (1.0 - remaining_distance / total_distance) * step_percentage
		progress = generation_progress * step_percentage + step_progress
		progress_label.text = str(progress) + "%"
		
		if current_cell != nearest_floor:
			if current_cell.x < nearest_floor.x: current_cell.x += 1
			elif current_cell.x > nearest_floor.x: current_cell.x -= 1
			elif current_cell.y < nearest_floor.y: current_cell.y += 1
			elif current_cell.y > nearest_floor.y: current_cell.y -= 1
			tilemap.set_floor(current_cell)
			
		else:
			generation_progress += 1
			finalize_generation()
		
	elif generation_progress == 5:
		var boss_threshold: int = int(enemy_count * boss_spawn_percentage / 100.0)
		if GlobalVariables.fight_room_index % 4 == 0 and get_tree().get_nodes_in_group("enemies").size() <= boss_threshold and \
		can_spawn_boss:
			can_spawn_boss = false
			generate_boss()
		if get_tree().get_nodes_in_group("enemies").size() == 0 and can_spawn_trapdoor:
			can_spawn_trapdoor = false
			var trapdoor = trapdoor_scene.instantiate()
			trapdoor.global_position = GlobalVariables.player_position
			add_child(trapdoor)
	
func finalize_generation() -> void:
	GlobalVariables.tilemap.set_floor(Vector2i(-1, -1), true)
	
	generate_enemies(enemy_count, enemies)
	generate_chests(1)
	
	GlobalVariables.dungeon_flower_targets.clear()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy is not DungeonFlower:
			GlobalVariables.dungeon_flower_targets.append(enemy)
			
	if GlobalVariables.fight_room_index > 16:
		generate_quitters()
			
	$Loading.queue_free()
			
	var player = player_scene.instantiate()
	player.global_position = tilemap.map_to_local(spawn_pos)
	add_child(player)

func generate_enemies(enemy_count: int, enemies: Dictionary) -> void:
	map.shuffle()
	var i: int
	while i < enemy_count:
		var enemy_scene: PackedScene = enemies.keys().pick_random()
		if enemies[enemy_scene] > 0:
			i += 1
			enemies[enemy_scene] -= 1
			var enemy = enemy_scene.instantiate()
			var location = map.pop_back()
			enemy.global_position = tilemap.map_to_local(location)
			add_child(enemy)
		else:
			enemies.erase(enemy_scene)

func generate_boss() -> void:
	var candidates: Array[Vector2i]
	var closest_candidate: Vector2i
	var closest_distance: float = INF
	var player_cell: Vector2i = tilemap.local_to_map(GlobalVariables.player_position)
	for x in range(map_size.x):
		for y in range(map_size.y):
			var pos = Vector2i(x, y)
			if pos not in dictionary_map:
				for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
					var neighbor = pos + dir
					if neighbor in dictionary_map:
						var distance = pos.distance_to(player_cell)
						if distance < closest_distance:
							closest_distance = distance
							closest_candidate = pos
							break
		
	var spawn_point: Vector2i = closest_candidate
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			tilemap.set_floor(Vector2i(spawn_point.x + x, spawn_point.y + y), true)
	var boss = bosses.pick_random().instantiate()
	boss.global_position = tilemap.to_global(tilemap.map_to_local(spawn_point))
	add_child(boss)
	
	MusicPlayer.change_music(preload("res://music/Blinded By Fight And Greed.ogg"))
	MusicPlayer.wall_break()

func generate_chests(chest_count: int) -> void:
	map.shuffle()
	for i in range(chest_count):
		var chest: Node2D = chest_scene.instantiate()
		var location = map.pop_back()
		chest.global_position = tilemap.map_to_local(location)
		add_child(chest)

var quitters_count: int = 20
var quitter_textures: Array[Texture] = [
	preload("res://sprites/noose.png"),
	preload("res://sprites/quitter1.png"),
	preload("res://sprites/quitter2.png"),
	preload("res://sprites/quitter3.png"),
	preload("res://sprites/quitter4.png"),
	preload("res://sprites/quitter5.png")
]
func generate_quitters() -> void:
	for i in range(quitters_count):
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = quitter_textures.pick_random()
		sprite.global_position = tilemap.map_to_local(tilemap.map.pick_random())
		var sprite_scale: float = randf_range(1.0, 2.0)
		sprite.scale = Vector2(sprite_scale, sprite_scale)
		sprite.z_index = 100
		sprite.modulate.a = 0.75
		add_child(sprite)
