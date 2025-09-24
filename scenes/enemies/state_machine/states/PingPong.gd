extends State

class_name PingPong

@onready var enemy: Enemy = get_parent().get_parent()
@export var state_duration_min: float
@export var state_duration_max: float
@export var min_speed: int = 1
@export var max_speed: int = 2
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
	var direction: Vector2 = enemy.direction
	if direction == Vector2.ZERO:
		direction = Vector2(randi_range(-max_speed, max_speed), randi_range(-max_speed, max_speed))
	for i in range(enemy.get_slide_collision_count()):
		var collision = enemy.get_slide_collision(i)
		var normal = collision.get_normal()
		if normal == Vector2.LEFT:
			direction.x = randi_range(-max_speed, -min_speed)
		elif normal == Vector2.RIGHT:
			direction.x = randi_range(min_speed, max_speed) 
		elif normal == Vector2.UP:
			direction.y = randi_range(-max_speed, -min_speed)
		elif normal == Vector2.DOWN:
			direction.y = randi_range(min_speed, max_speed)
			
	enemy.direction = direction
