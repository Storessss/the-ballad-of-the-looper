extends State

class_name SpawnEnemy

@onready var enemy: Enemy = get_parent().get_parent()
@export var enemy_scenes: Array[PackedScene]
@export var enemy_count_min: int
@export var enemy_count_max: int
@export var disable_enemy_avoidance: bool
@export var next_state: State

var state_duration: float

func Enter() -> void:
	for i in range(randi_range(enemy_count_min, enemy_count_max)):
		var spawned_enemy: Enemy = enemy_scenes.pick_random().instantiate()
		spawned_enemy.global_position = enemy.global_position
		if disable_enemy_avoidance:
			spawned_enemy.nav_agent_movement = false
		get_tree().current_scene.add_child(spawned_enemy)
	Transitioned.emit(self, next_state)
