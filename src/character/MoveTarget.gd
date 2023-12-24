class_name MoveTarget
extends Node

signal start_action()

@export var move: Move

var target_pos

func enter(pos):
	target_pos = pos

func update(delta: float):
	if target_pos != null:
		var dist = move.body.global_position.distance_to(target_pos)
		if dist < 5:
			start_action.emit()
		else:
			move.do_move(move.body.global_position.direction_to(target_pos))
	else:
		start_action.emit()
