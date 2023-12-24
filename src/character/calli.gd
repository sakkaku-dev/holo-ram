extends Character

signal summon_finished

@export var count := 4
@export var summon_delay := 1.0

var cards: Array[Vector2]
var finished = 0
var actual_count := 0

func _create_event():
	cards = []
	finished = 0
	for _i in range(count):
		var card = queue.get_data().random_card(cards)
		if card == null:
			break
		
		cards.append(card)

	actual_count = cards.size()
	queue.do_event(SwapInOrderEvent.new(cards.duplicate()), summon_finished)
	summon_hands()

func _on_finish():
	finished += 1
	if finished == count:
		summon_finished.emit()
		finish_action()

func summon_hands():
	if cards.size() == 0:
		return
	
	var c = cards.pop_front()
	var node = board.get_card_node(c) as Card
	node.summon()
	if not node.summon_finished.is_connected(_on_finish):
		node.summon_finished.connect(_on_finish)
	get_tree().create_timer(summon_delay).timeout.connect(func(): summon_hands())
