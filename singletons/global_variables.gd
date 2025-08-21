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
var room: int = 1

var comp: int
var fire_rate_multiplier: float = 1.0
var damage_multiplier: float = 1.0
var previous_comp: int

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	if player:
		player_position = player.global_position
		
	#if comp == 0:
		#fire_rate_multiplier = 1.0
		#damage_multiplier = 1.0
	#elif comp < 0:
		#fire_rate_multiplier = 1.0 - 0.1 * abs(comp)
		#damage_multiplier = 1.0 + 0.1 * abs(comp)
	#elif comp > 0:
		#fire_rate_multiplier = 1.0 + 0.1 * abs(comp)
		#damage_multiplier = 1.0 - 0.1 * abs(comp)
	#fire_rate_multiplier = clamp(fire_rate_multiplier, 0.5, 2.0)
	#damage_multiplier = clamp(damage_multiplier, 0.5, 2.0)
	
	if comp >= 10:
		comp = 0
		fire_rate_multiplier += 0.25
		damage_multiplier += 0.25
	comp = max(comp, -10)
	
