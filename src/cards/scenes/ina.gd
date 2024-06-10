extends Character

signal tentacles_finished

@export var tentacle_scene: PackedScene

var finished = 0
var spawned = []
var neighbors_with_data = []

func do_action():
	var coord = get_current_coord()
	neighbors_with_data = queue.get_data().get_neighbors(coord, false, true)
	if neighbors_with_data.is_empty():
		return
	
	await to_current_field()
	start_action("action")
	
	queue.do_event(SpinEvent.new(coord, queue.get_data()), tentacles_finished)

func _on_finished():
	finished += 1
	if finished == spawned.size():
		tentacles_finished.emit()
		finish_action()

func spawn_tentacles():
	finished = 0
	spawned = []

	var coord = get_current_coord()
	var data = queue.get_data()
	var neighbors = data.get_neighbors(coord)
	
	for neighbor in neighbors_with_data:
		var dir = coord.direction_to(neighbor)
		var target = _next_free_neighbor(coord, neighbor, neighbors)
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

func _next_free_neighbor(coord: Vector2, curr: Vector2, neighbors: Array[Vector2]):
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
	tentacle.global_position = global_position
	return tentacle

func _in_neighbors(v: Vector2, neighbors: Array[Vector2]):
	for n in neighbors:
		if n.x == v.x and n.y == v.y:
			return true
	return false
