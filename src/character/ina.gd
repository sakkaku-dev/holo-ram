extends Character

func do_action(board: Board):
	var pos = board.get_position_in_front(global_position, dir)
	target_pos = pos
