extends Character

func do_action(data: DataEventQueue):
	self.target_pos = global_position
	data.undo_event()
