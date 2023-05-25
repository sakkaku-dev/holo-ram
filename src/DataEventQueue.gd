class_name DataEventQueue
extends Node

signal updated()
signal cleared()
signal unlocked()
signal locked()

var event_queue: Array[EventAction] = []
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

func do_event(ev: EventAction):
	ev.do(current_data)
	event_queue.append(ev)
	updated.emit()
	
	if locked:
		is_locked = false
		unlocked.emit()
	
	if current_data.get_card_count(1) == 0:
		cleared.emit()

func lock():
	is_locked = true
	locked.emit()
