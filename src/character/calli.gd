extends Character

@export var count := 5

func _create_event():
	var cards: Array[Vector2] = []
	for _i in range(count):
		var card = queue.get_data().random_card(cards)
		if card == null:
			break
		
		cards.append(card)
	
	queue.do_event(SwapInOrderEvent.new(cards), action_finished)
	
