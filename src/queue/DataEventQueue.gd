class_name DataEventQueue
extends Node

signal updated()
signal cleared()
signal unlocked()
signal locked()

var event_queue: Array[Dictionary] = []
var event_history: Array[EventAction] = []
var current_data: DataSnapshot
var size = 0
var is_locked = false

func init_data(cards: Array[CardResource]):
	var total_cards = cards.size() * 2
	var board_size = int(ceil(sqrt(total_cards)))
	var data: Array[Array] = []
	size = board_size
	
	var random_cards = cards.duplicate()
	random_cards.append_array(cards.duplicate())
	random_cards.shuffle()
	
	for row in range(0, board_size):
		var row_data = []
		for col in range(0, board_size):
			row_data.append(random_cards.pop_front())
		data.append(row_data)
	
	current_data = DataSnapshot.new(data)

func get_data(clone = false) -> DataSnapshot:
	if clone:
		return current_data.clone()
	return current_data

func do_event(ev: EventAction, wait_for = null):
	event_queue.append({"event": ev, "wait": wait_for})

func _process(_delta):
	var obj = event_queue.pop_front()
	if obj:
		is_locked = true

		var ev = obj["event"]
		var wait = obj["wait"]

		if wait:
			await wait

		if ev is UndoEvent:
			_undo_event()
		else:
			ev.do(current_data)
			event_history.append(ev)

		_check_after_change()
		is_locked = false

func _undo_event():
	var ev: EventAction = event_history.pop_back()
	if ev:
		ev.undo(current_data)

func _check_after_change():
	updated.emit()
	
	if current_data.get_card_count(1) == 0:
		cleared.emit()
