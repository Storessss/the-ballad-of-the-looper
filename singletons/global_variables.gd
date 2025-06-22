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

var shake = false
var random_strength = 30.0
var shake_fade = 5.0
var rnd = RandomNumberGenerator.new()
var shake_strength = 0.0

func apply_shake():
	shake_strength = random_strength
func randomOffset():
	return Vector2(rnd.randf_range(- shake_strength, shake_strength), randf_range(- shake_strength, shake_strength))

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	player_position = player.global_position
	
	if shake:
		apply_shake()
		shake = false
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
