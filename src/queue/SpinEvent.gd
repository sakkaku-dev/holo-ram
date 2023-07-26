class_name SpinEvent
extends EventAction

var origin: Vector2
var neighbors: Array[Vector2]

func _init(v: Vector2, data: DataSnapshot):
	origin = v
	neighbors = data.get_neighbors(origin)

func get_affected():
	return neighbors

func do(data: DataSnapshot):
	_spin(data, neighbors)

func undo(data: DataSnapshot):
	var reversed = neighbors.duplicate()
	reversed.reverse()
	_spin(data, reversed)

func _spin(data: DataSnapshot, neighbors: Array[Vector2]):
	assert(neighbors.size() >= 2)
	
	var values = []
	for n in neighbors:
		values.append(data.get_card(n))
		
	for i in range(0, neighbors.size()):
		var idx = i - 1 if i != 0 else neighbors.size() - 1
		var n = neighbors[i]
		data.set_card(n, values[idx])
