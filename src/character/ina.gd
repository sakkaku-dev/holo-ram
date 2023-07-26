extends Character

signal tentacles_finished

@export var tentacle_scene: PackedScene

var coord: Vector2
var queue: DataEventQueue

var finished = 0
var spawned = []

func do_action(data: DataEventQueue):
	queue = data
	coord = board.get_coord_for(global_position)
	self.target_pos = board.get_global_position_for(coord)
	
	finished = 0
	spawned = []

func _on_finished():
	finished += 1
	if finished == spawned.size():
		tentacles_finished.emit()

func spawn_tentacles():
	var data = queue.get_data()
	var neighbors = data.get_neighbors(coord)
	var cards = neighbors.duplicate()
	cards.append(coord)
	queue.do_event(SpinEvent.new(coord, data), tentacles_finished)
	
	var neighbors_with_data = []
	for n in neighbors:
		if data.has_data(n):
			neighbors_with_data.append(n)
	
	for neighbor in neighbors_with_data:
		var dir = coord.direction_to(neighbor)
		var target = _next_free_neighbor(neighbor, neighbors)
		if target == null:
			spawned -= 1
			print("No available next neighbor found for %s in %s" % [neighbor, neighbors])
			continue
		
		var tentacle = _create_tentacle()
		spawned.append(tentacle)
		
		var target_dir = coord.direction_to(target)
		board.hide_card(neighbor)
		tentacle.move(dir, target_dir)
	
	for t in spawned:
		t.finished.connect(_on_finished)

func _next_free_neighbor(curr: Vector2, neighbors: Array[Vector2]):
	var rot_delta = -PI/2
	
	var dir = coord.direction_to(curr)
	var matching_cross = 2 # cross can only be until 1
	var matching = null
	for n in neighbors:
		if n == curr: continue
		
		var neighbor_dir = coord.direction_to(n)
		var cross = dir.cross(neighbor_dir)
		
		if cross < matching_cross:
			matching_cross = cross
			matching = n
		
	return matching
	
func _create_tentacle():
	var tentacle = tentacle_scene.instantiate() as Tentacle
	add_child(tentacle)
	move_child(tentacle, 0)
	tentacle.global_position = target_pos
	return tentacle

func _in_neighbors(v: Vector2, neighbors: Array[Vector2]):
	for n in neighbors:
		if n.x == v.x and n.y == v.y:
			return true
	return false
