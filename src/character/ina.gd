extends Character

@export var tentacle_scene: PackedScene

var coord: Vector2
var data: DataEventQueue

var finished = 0
var spawned = []

func do_action(data: DataEventQueue):
	self.data = data
	coord = board.get_coord_for(global_position)
	target_pos = board.get_global_position_for(coord)
	finished = 0
	spawned = []

func _on_finished():
	finished += 1
	if finished == spawned.size():
		data.do_event(SpinEvent.new(coord))

func spawn_tentacles():
	var neighbors = data.current_data.get_neighbors(coord)
	
	var neighbors_with_data = []
	for n in neighbors:
		if data.current_data.has_data(n):
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

func _in_neighbors(coord: Vector2, neighbors: Array[Vector2]):
	for n in neighbors:
		if n.x == coord.x and n.y == coord.y:
			return true
	return false
