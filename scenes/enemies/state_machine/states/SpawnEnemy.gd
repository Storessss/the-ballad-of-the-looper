extends State

class_name SpawnEnemy

@onready var enemy: Enemy = get_parent().get_parent()
@export var enemy_scenes: Array[PackedScene]
@export var enemy_count_min: int
@export var enemy_count_max: int
@export var next_state: State

var state_duration: float

func Enter() -> void:
	for i in range(randi_range(enemy_count_min, enemy_count_max)):
		var spawned_enemy: Enemy = enemy_scenes.pick_random().instantiate()
		spawned_enemy.global_position = enemy.global_position
		get_tree().current_scene.add_child(spawned_enemy)
	Transitioned.emit(self, next_state)
