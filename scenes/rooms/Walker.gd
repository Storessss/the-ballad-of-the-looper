extends Node

class_name Walker

const DIRECTIONS = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

var position: Vector2i
var direction := Vector2i.RIGHT
var borders: Rect2
var step_history: Array[Vector2i]
var steps_since_turn: int

func _init(starting_position: Vector2i, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	
func walk(steps: int) -> Array[Vector2i]:
	for i in range(steps):
		if randf() <= 0.25 or steps_since_turn >= 4:
			change_direction()
			
		if step():
			step_history.append(position)
		else:
			change_direction()
			
	return step_history
	
func step() -> bool:
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	return false
	
func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
	
	
