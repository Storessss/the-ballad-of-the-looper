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
	
func walk(steps: int, radius: int = 1) -> Array[Vector2i]:
	var carved_history: Array[Vector2i]
	for i in range(steps):
		if randf() <= 0.45 or steps_since_turn >= 7:
			change_direction()
			
		if step():
			step_history.append(position)
			carved_history.append_array(carve(position, radius))
		else:
			change_direction()
			
	return carved_history
	
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
	
func carve(pos: Vector2i, radius: int) -> Array[Vector2i]:
	var cells: Array[Vector2i]
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var cell = pos + Vector2i(x, y)
			if borders.has_point(cell):
				cells.append(cell)
	return cells
