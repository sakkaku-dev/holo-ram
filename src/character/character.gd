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


@export var move_to_closest := false
@export var move_closest_available := false
@export var finish_on_action := true

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var board: Board = get_tree().get_first_node_in_group("board")

var queue: DataEventQueue 
var move: Move
var move_target: MoveTarget

var state = MOVE
var coord: Vector2
var closest_available: Vector2

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	move = Move.new()
	move.body = self
	move.sprite = get_node("CollisionShape2D")
	move.anim = anim
	add_child(move)
	
	move_target = MoveTarget.new()
	move_target.move = move
	add_child(move_target)
	
	anim.animation_finished.connect(_on_anim_finished)
	move_target.start_action.connect(func(): _action())
	
func _action():
	state = ACTION
	_create_event()
	anim.play("action")

func _on_anim_finished(anim_name: String):
	if anim_name == "action" and finish_on_action:
		finish_action()

func finish_action():
	action_finished.emit()
	move_target.enter(null)
	get_tree().create_timer(action_cooldown_time).timeout.connect(func(): action_cooldown.emit())
	state = MOVE

func _physics_process(delta):
	match state:
		MOVE: move.update(delta)
		MOVE_TARGET: move_target.update(delta)

func _create_event():
	pass
	
func do_action():
	if move_to_closest:
		coord = Vector2(board.get_coord_for(global_position))
		if move_closest_available:
			closest_available = queue.get_data().get_closest_card_coord(coord, move.dir)
			if closest_available:
				to_target(board.get_global_position_for(closest_available))
		else:
			to_target(board.get_global_position_for(coord))
	else:
		to_target(global_position)

func to_target(pos: Vector2):
	move_target.enter(global_position)
	state = MOVE_TARGET
