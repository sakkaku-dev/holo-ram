class_name MatchEvent
extends EventAction

var data1: Vector2
var data2: Vector2

func _init(d1: Vector2, d2: Vector2):
	data1 = d1
	data2 = d2


func do(data: DataSnapshot):
	data.set_card(data1, null)
	data.set_card(data2, null)


func undo(data: DataSnapshot):
	pass # TODO: should we allow it?
