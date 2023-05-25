class_name SpinEvent
extends EventAction

var origin: Vector2

func _init(v: Vector2):
	origin = v

func do(data: DataSnapshot):
	var neighbors = data.get_neighbors(origin)
	_spin(data, neighbors)

func undo(data: DataSnapshot):
	var neighbors = data.get_neighbors(origin)
	neighbors.reverse()
	_spin(data, neighbors)

func _spin(data: DataSnapshot, neighbors: Array[Vector2]):
	assert(neighbors.size() >= 2)
	
	var curr = null
	for i in range(0, neighbors.size()):
		var n = neighbors[i]
		if i == 0:
			curr = data.get_card(n)
			data.set_card(n, data.get_card(neighbors[neighbors.size() - 1]))
			continue
		
		var temp = data.get_card(n)
		data.set_card(n, curr)
		curr = temp
