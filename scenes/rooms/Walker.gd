extends Node

class_name Walker

const DIRECTIONS = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

var position: Vector2i
var direction := Vector2i.RIGHT
var borders: Rect2
var step_history: Array[Vector2i]
var steps_since_turn: int

var walk_active: bool
var carved_history: Array[Vector2i]
var steps: int
var radius: int
var i: int

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
	
func activate_walk(steps_input: int, radius_input: int = 1):
	walk_active = true
	carved_history.clear()
	steps = steps_input
	radius = radius_input
	i = 0
	
func _process(_delta: float) -> void:
	if walk_active:
		
		get_parent().step_progress = float(i) / float(steps) * get_parent().step_percentage
		get_parent().progress = get_parent().generation_progress * get_parent().step_percentage + get_parent().step_progress
		get_parent().progress_label.text = str(get_parent().progress) + "%"
		
		get_parent().generated = 0
		get_parent().generation_quota = 75
		while get_parent().generated < get_parent().generation_quota and get_parent().generation_progress == 1:
			i += 1
			if i >= steps:
				walk_active = false
				get_parent().map = carved_history
				
			if randf() <= 0.45 or steps_since_turn >= 7:
				change_direction()
				
			if step():
				step_history.append(position)
				carved_history.append_array(carve(position, radius))
			else:
				change_direction()
			
			get_parent().generated += 1
			
	
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
