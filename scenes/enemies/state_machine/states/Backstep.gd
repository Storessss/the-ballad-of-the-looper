extends State

class_name Backstep

@onready var enemy: Enemy = get_parent().get_parent()
@export var distance: int
@export var speed_multiplier: float = 1.0
@export var animation: String
@export var next_state: State

var animations_flip: bool

func Enter() -> void:
	var move_direction: Vector2 = (GlobalVariables.player_position - enemy.global_position).normalized()
	var move_point: Vector2 = enemy.global_position - move_direction * distance
	if enemy.line_of_sight(enemy.global_position, move_point):
		enemy.nav.target_position = move_point
	else:
		Transitioned.emit(self, next_state)
	animations_flip = enemy.animations.flip_h

func Update(delta: float) -> void:
	if animation:
		enemy.animations.play(animation)
	enemy.animations.flip_h = animations_flip

func Physics_Update(_delta: float) -> void:
	if enemy.nav.is_navigation_finished():
		Transitioned.emit(self, next_state)
	else:
		var next_position = enemy.nav.get_next_path_position()
		enemy.direction = (next_position - enemy.global_position).normalized() * speed_multiplier
