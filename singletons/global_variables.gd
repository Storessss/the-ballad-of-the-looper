extends Node

var dashing: bool
var graced: bool

var controller: bool = true

var inventory_index: int

var player: CharacterBody2D
var player_position: Vector2
var player_health: int = 5

var limit_right: int
var limit_bottom: int

func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	player_position = player.global_position
