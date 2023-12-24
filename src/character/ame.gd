extends Character

func do_action():
	start_action()
	queue.do_event(UndoEvent.new())
