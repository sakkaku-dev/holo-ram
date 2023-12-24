class_name Character
extends CharacterBody2D

signal action_cooldown()
signal action_finished()

enum {
	MOVE,
	MOVE_TARGET,
	ACTION,
}

@export var action_cooldown_time := 5.0

@onready var board: Board = get_tree().get_first_node_in_group("board")
@onready var move = $Move
@onready var move_target = $MoveTarget
@onready var animation_player = $AnimationPlayer

var queue: DataEventQueue
var state = MOVE

func finish_action():
	state = MOVE
	action_finished.emit()
	get_tree().create_timer(action_cooldown_time).timeout.connect(func(): action_cooldown.emit())

func _physics_process(delta):
	match state:
		MOVE: move.update(delta)
		MOVE_TARGET: move_target.update(delta)

func do_action():
	pass

func start_action(anim = null):
	state = ACTION
	if anim:
		animation_player.play(anim)

func to_closest_card():
	var coord = get_current_coord()
	var closest_available = queue.get_data().get_closest_card_coord(coord, move.dir)
	if closest_available:
		await _to_target(closest_available)

func to_current_field():
	var coord = get_current_coord()
	await _to_target(coord)

func _to_target(pos: Vector2):
	move_target.enter(board.get_global_position_for(pos))
	state = MOVE_TARGET
	await move_target.start_action

func get_current_coord():
	return Vector2(board.get_coord_for(global_position))
