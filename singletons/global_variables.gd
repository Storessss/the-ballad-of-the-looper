extends Node

var dashing: bool
var graced: bool

var controller: bool = true

var first_time_inventory_instantiation: bool = true
var inventory: Array[PackedScene]
var weapon_states: Array[Dictionary]
var inventory_index: int
var previous_inventory_index: int
var weapon_durability: int
var weapon_full_durability: int
var inventory_index_rounder: int
func append_to_inventory(item_scene: PackedScene) -> void:
	inventory.append(item_scene)
	var item: Node2D = item_scene.instantiate()
	if item is Weapon:
		weapon_states.append({
			"previous_reload_time": 0.0,
			"previous_durability": item.full_durability,
		})
	else:
		weapon_states.append({})
func remove_from_inventory(caller: Node2D, index: int = inventory_index) -> void:
	GlobalVariables.inventory.pop_at(index)
	GlobalVariables.weapon_states.pop_at(index)
	GlobalVariables.inventory_index_rounder = -1
	caller.queue_free()
func replace_in_inventory(item_scene: PackedScene, index: int = inventory_index) -> void:
	inventory[index] = item_scene
	var item: Node2D = item_scene.instantiate()
	if item is Weapon:
		weapon_states[index] = {
			"previous_reload_time": 0.0,
			"previous_durability": item.full_durability,
		}
	else:
		weapon_states[index] = {}

var player: CharacterBody2D
var player_position: Vector2
var player_max_health: int = 6
var player_health: int = player_max_health
signal player_health_changed

var left: int
var top: int
var right: int
var bottom: int

var tilemap: TileMapLayer
var room: int = 1

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

func _physics_process(delta: float) -> void:
	# Global Debug
	pass
