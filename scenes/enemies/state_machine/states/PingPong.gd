extends State

class_name PingPong

@onready var enemy: Enemy = get_parent().get_parent()
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: State

var state_duration: float

func Enter() -> void:
	state_duration = randf_range(state_duration_min, state_duration_max)

func Update(delta: float) -> void:
	state_duration -= delta
	if state_duration > 0:
		state_duration -= delta
	else:
		Transitioned.emit(self, next_state)
	if animation:
		enemy.animations.play(animation)
		

func Physics_Update(_delta: float) -> void:
	var direction = enemy.direction
	if direction == Vector2.ZERO:
		var angle = randf() * TAU
		direction = Vector2(cos(angle), sin(angle))

	for i in range(enemy.get_slide_collision_count()):
		var collision = enemy.get_slide_collision(i)
		var normal = collision.get_normal()
		
		direction = direction.bounce(normal)
		
	enemy.direction = direction.normalized()
