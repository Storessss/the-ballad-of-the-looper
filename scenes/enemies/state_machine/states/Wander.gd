extends State

class_name Wander

@onready var enemy: Enemy = get_parent().get_parent()
@export var distance_min: int = 20
@export var distance_max: int = 100
@export var animation: String
@export var next_state: State

func Enter() -> void:
	await get_tree().process_frame
	var offset := Vector2.ZERO
	while not enemy.line_of_sight(enemy.global_position, enemy.global_position + offset) or \
	offset == Vector2.ZERO:
		var angle = randf() * TAU
		var distance = randf_range(distance_min, distance_max)
		offset = Vector2(cos(angle), sin(angle)) * distance
	
	enemy.nav.target_position = enemy.global_position + offset

func Update(delta: float) -> void:
	if animation:
		enemy.animations.play(animation)

func Physics_Update(_delta: float) -> void:
	if enemy.nav.is_navigation_finished():
		Transitioned.emit(self, next_state)
	else:
		var next_position = enemy.nav.get_next_path_position()
		enemy.direction = (next_position - enemy.global_position).normalized()
