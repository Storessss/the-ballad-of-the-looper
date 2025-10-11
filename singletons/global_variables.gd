extends Node

var dashing: bool
var graced: bool

var controller: bool = true

var first_time_inventory_instantiation: bool = true
var inventory: Array[PackedScene]
var weapon_states: Dictionary
var inventory_index: int
var previous_inventory_index: int

var player: CharacterBody2D
var player_position: Vector2
var player_max_health: int = 6
var player_health: int = player_max_health
signal player_hit

var left: int
var top: int
var right: int
var bottom: int

var tilemap: TileMapLayer
var room: int = 3

var fire_rate_multiplier: float = 1.0
var damage_multiplier: float = 1.0

var dims: int

var dungeon_flower_targets: Array[Enemy]

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	if player:
		player_position = player.global_position
		
		
func change_room():
	room += 1
	for dim in get_tree().get_nodes_in_group("dims"):
		GlobalVariables.dims += 1
	get_tree().call_deferred("reload_current_scene")
