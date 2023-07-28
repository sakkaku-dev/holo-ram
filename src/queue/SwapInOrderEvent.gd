class_name SwapInOrderEvent
extends EventAction

var coords: Array[Vector2]

func _init(c: Array[Vector2]):
	coords = c

func get_affected():
	return coords.duplicate()

func do(data: DataSnapshot):
	_swap_in_order(coords, data)

func undo(data: DataSnapshot):
	var reversed = coords.duplicate()
	reversed.reverse()
	_swap_in_order(reversed, data)

func _swap_in_order(pos: Array[Vector2], data: DataSnapshot):
	var temp = null
	for i in range(pos.size()):
		var p1 = pos[i]
		var p2 = pos[i+1] if i < pos.size() - 1 else pos[0]


		var v1 = data.get_card(p1) if temp == null else temp
		var v2 = data.get_card(p2)

		data.set_card(p2, v1)
		temp = v2