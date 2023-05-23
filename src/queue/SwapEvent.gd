class_name SwapEvent
extends EventAction

var target: Vector2
var dest: Vector2

func _init(t: Vector2, d: Vector2):
	target = t
	dest = d


func do(data: DataSnapshot):
	_swap(data, target, dest)


func undo(data: DataSnapshot):
	_swap(data, dest, target)


func _swap(data: DataSnapshot, v1: Vector2, v2: Vector2):
	var dest_value = data.get_card(v2)
	data.set_card(v2, data.get_card(v1))
	data.set_card(v1, dest_value)
