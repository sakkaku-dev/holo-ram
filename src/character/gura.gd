extends Character

var coord: Vector2
var data: DataEventQueue

var swap_card

func do_action(data: DataEventQueue):
	self.data = data
	coord = board.get_coord_for(global_position)
	self.target_pos = board.get_global_position_for(coord)

func select_random_card():
	swap_card = data.current_data.random_card(coord)
	if swap_card == null:
		print("No more cards to swap with")
		return
	
	board.disable_cards([coord, swap_card])

func swap():
	if swap_card != null:
		global_position = board.get_global_position_for(swap_card)
		data.do_event(SwapEvent.new(coord, swap_card))
