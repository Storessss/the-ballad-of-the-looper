extends Node

var dashing: bool
var graced: bool

var controller: bool = true

var inventory_index: int

var player_position: Vector2
var player_health: int = 5

func _process(_delta: float) -> void:
	player_position = get_tree().get_first_node_in_group("players").global_position
