class_name DataSnapshot

var data: Array = []
var _available_cards = []
var _empty_pos = []

func _init(d: Array):
	data = d.duplicate(true)

func clone():
	return DataSnapshot.new(data)

func _index_available_cards():
	_available_cards = []
	_empty_pos = []
	for y in range(0, data.size()):
		for x in range(0, data[y].size()):
			var coord = Vector2(x, y)
			if has_data(coord):
				_available_cards.append(coord)
			else:
				_empty_pos.append(coord)

func get_neighbors(coord: Vector2, include_diagonal = false) -> Array[Vector2]:
	var top = coord + Vector2.UP
	var left = coord + Vector2.LEFT
	var bot = coord + Vector2.DOWN
	var right = coord + Vector2.RIGHT
	
	var neighbors: Array[Vector2] = []
	var all = [top, left, bot, right] # should be counterclock wise for spinning
	
	if include_diagonal:
		var top_left = top + Vector2.LEFT
		var top_right = top + Vector2.RIGHT
		var bot_left = bot + Vector2.LEFT
		var bot_right = bot + Vector2.RIGHT
		all.append_array([top_left, top_right, bot_left, bot_right]) # not used for spinning, so order not important
	
	for n in all: 
		if is_inside(n):
			neighbors.append(n)
	return neighbors

func is_inside(coord: Vector2):
	return coord.x >= 0 and coord.x < data[0].size() and \
		coord.y >= 0 and coord.y < data.size()

func has_data(coord: Vector2):
	return get_card(coord) != null

func set_card(coord: Vector2, v):
	if is_inside(coord):
		data[coord.y][coord.x] = v

func get_card(coord: Vector2):
	if is_inside(coord):
		return data[coord.y][coord.x]
	return null

func get_card_count(max_count = -1):
	var count = 0
	for i in range(data.size()):
		for j in range(data[i].size()):
			if data[i][j] != null:
				count += 1
				if max_count != -1 and count >= max_count:
					break
	return count

func random_card(exclude: Array[Vector2] = []):
	_index_available_cards()
	_available_cards.shuffle()
	
	for c in _available_cards:
		if not c in exclude:
			return c

	return null

func random_free():
	_index_available_cards()
	return _empty_pos.pick_random()

func get_closest_card_coord(coord: Vector2, dir := Vector2.ZERO):
	if has_data(coord):
		return coord
	
	var neighbors = get_neighbors(coord, true).map(func(x): return {"coord": x, "dot": coord.direction_to(x).dot(dir)})
	neighbors.sort_custom(func(a, b): return a.dot > b.dot)
	
	for n in neighbors:
		if has_data(n.coord):
			return n.coord
	
	return null
