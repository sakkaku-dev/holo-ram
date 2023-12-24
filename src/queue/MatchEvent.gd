class_name MatchEvent
extends EventAction

signal matched(value)
signal wrong_match()

var data1: Vector2
var data2: Vector2

func _init(d1: Vector2, d2: Vector2):
	data1 = d1
	data2 = d2

func get_affected():
	return [data1, data2]

func do(data: DataSnapshot):
	var card1 = data.get_card(data1)
	var card2 = data.get_card(data2)
	print(card1 == card2)
	if card1 == card2:
		data.set_card(data1, null)
		data.set_card(data2, null)
		matched.emit(card1)
	else:
		wrong_match.emit()


func undo(data: DataSnapshot):
	pass # TODO: should we allow it?
