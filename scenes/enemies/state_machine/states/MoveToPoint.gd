extends State

class_name MoveToPoint

@onready var enemy: Enemy = get_parent().get_parent()
@export var points: Array[Vector2]
@export var animation: String
@export var next_state: State

func Enter() -> void:
	await get_tree().process_frame$
	var point = points.pick_random()
	var move_point = Vector2(GlobalVariables.right * point.x, GlobalVariables.bottom * point.y)
	enemy.nav.target_position = move_point

func Update(delta: float) -> void:
	if enemy.nav.is_navigation_finished():
		Transitioned.emit(self, next_state)
	if animation:
		enemy.animations.play(animation)

func Physics_Update(_delta: float) -> void:
	if NavigationServer3D.map_get_iteration_id(enemy.nav.get_navigation_map()) == 0:
		return
	var next_position = enemy.nav.get_next_path_position()
	enemy.direction = (next_position - enemy.global_position).normalized()
