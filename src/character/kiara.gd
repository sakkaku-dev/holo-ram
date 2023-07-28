extends Character

var card: Vector2
var card_node: Card

func _create_event():
	card = queue.get_data().random_free()
	if card == null:
		card = coord
	
	card_node = board.get_card_node(card)
	queue.do_event(SwapEvent.new(coord, card), action_finished)

func burn_card():
	card_node.burn()

func burn_away_card():
	card_node.burn_away()

func move_to_card():
	if card:
		global_position = board.get_global_position_for(card)
