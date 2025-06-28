extends Node

var dashing: bool
var graced: bool

var controller: bool = true

var inventory_index: int

var player: CharacterBody2D
var player_position: Vector2
var player_max_health: int = 6
var player_health: int = player_max_health
signal player_hit

var left: int
var top: int
var right: int
var bottom: int

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	player_position = player.global_position
