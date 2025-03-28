extends Node

class_name Walker_room

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var borders: Rect2 = Rect2()
var step_history = []
var steps_since_turn: float = 0
var rooms = []

func _init(starting_pos: Vector2, new_borders: Rect2) -> void:
	assert(new_borders.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_borders

func walk(steps):
	place_room(position)
	
	for step in steps:
		if steps_since_turn >= 7.5:
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
	else:
		return false

func change_direction() -> void:
	place_room(position)
	
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position: Vector2, size):
	return {position = position, size = size}

func place_room(position: Vector2) -> void:
	var size: Vector2 = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size / 2).floor()
	rooms.append(create_room(position, size))
	
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_back()
	var starting_position = step_history.front()
	
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
