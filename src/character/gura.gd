extends Character

var swap_card

func _create_event():
	swap_card = queue.get_data().random_card(coord)
	if swap_card == null:
		print("No more cards to swap with")
		return null
	
	queue.do_event(SwapEvent.new(coord, swap_card), action_finished)

func swap():
	if swap_card != null:
		global_position = board.get_global_position_for(swap_card)
