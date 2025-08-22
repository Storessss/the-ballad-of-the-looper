extends State

class_name IfEnemyGroupLeft

#@onready var enemy: Enemy = get_parent().get_parent()
@export var enemy_group_names: Array[String]
@export var next_state: State
@export var exit_state: State

var passed: bool = true

func Enter() -> void:
	await get_tree().process_frame
	passed = true
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var enemy_groups: Array[StringName] = enemy.get_groups()
		var matched: bool
		for allowed_group in enemy_group_names:
			if allowed_group in enemy_groups:
				matched = true
				break
		if not matched:
			passed = false
			break
			
	if passed:
		Transitioned.emit(self, next_state)
	else:
		Transitioned.emit(self, exit_state)
