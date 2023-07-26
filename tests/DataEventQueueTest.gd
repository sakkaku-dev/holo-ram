extends GutTest

func test_queue_history():
	var queue = autofree(DataEventQueue.new())
	var level = load("res://src/levels/HoloMyth.tres")
	queue.init_data(level.cards) # assuming 5 cards
	watch_signals(queue)
	assert_eq(queue.size, 4)

	var start_data = queue.get_data(true)

	queue.do_event(SpinEvent.new(Vector2(1, 1), queue.get_data()))
	simulate(queue, 1, 1)
	queue.do_event(SwapEvent.new(Vector2(0, 1), Vector2(0, 0)))
	simulate(queue, 1, 1)
	queue.do_event(UndoEvent.new())
	simulate(queue, 1, 1)
	queue.do_event(UndoEvent.new())
	simulate(queue, 1, 1)

	assert_signal_emit_count(queue, 'updated', 4)
	assert_eq_deep(queue.get_data().data, start_data.data)

func test_emit_cleared():
	var queue = autofree(DataEventQueue.new())
	var cards = [load("res://src/cards/Ina.tres")] as Array[CardResource]
	queue.init_data(cards)
	watch_signals(queue)

	var data = queue.get_data()
	var first = data.random_card()
	var second = data.random_card(first)

	queue.do_event(MatchEvent.new(first, second))
	simulate(queue, 1, 1)

	assert_signal_emitted(queue, 'cleared')
	
