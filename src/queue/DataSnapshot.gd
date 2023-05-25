class_name DataSnapshot

var data: Array = []

func _init(d: Array):
	data = d.duplicate(true)

func get_neighbors(coord: Vector2) -> Array[Vector2]:
	var top = Vector2(coord.x, coord.y - 1)
	var left = Vector2(coord.x - 1, coord.y)
	var bot = Vector2(coord.x, coord.y + 1)
	var right = Vector2(coord.x + 1, coord.y)
	var neighbors: Array[Vector2] = []
	for n in [top, left, bot, right]: # should be counterclock wise for spinning
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
