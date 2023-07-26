extends Character

func _create_event():
	queue.do_event(UndoEvent.new())
