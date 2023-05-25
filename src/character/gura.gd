extends Character

var coord: Vector2
var data: DataEventQueue

func do_action(data: DataEventQueue):
	self.data = data
	coord = board.get_coord_for(global_position)
	target_pos = board.get_global_position_for(coord)

func move_to_random_card():
	# TODO: disable cards
	var swap_card = data.current_data.random_card(coord)
	if swap_card == null:
		print("No more cards to swap with")
		return
	
	global_position = board.get_global_position_for(swap_card)
	data.do_event(SwapEvent.new(coord, swap_card))
	target_pos = null
