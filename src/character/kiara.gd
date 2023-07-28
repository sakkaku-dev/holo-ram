extends Character

var card

func _create_event():
	card = queue.get_data().random_free()
	if card == null:
		card = coord
	
	queue.do_event(SwapEvent.new(coord, card), action_finished)

func move_to_card():
	if card:
		global_position = board.get_global_position_for(card)
