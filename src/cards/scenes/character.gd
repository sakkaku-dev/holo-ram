class_name Character
extends CharacterBody2D

signal spawn(point)
signal clicked()
signal action_cooldown()
signal action_finished()

enum {
	MOVE,
	MOVE_TARGET,
	ACTION,
}

@export var merge_count := 100
@export var merge_scale := 1.3
@export var res: CardResource
@export var mouse_event: MouseEvent
@export var action_cooldown_time := 5.0
@export var point_scene: PackedScene

@onready var board: Board = get_tree().get_first_node_in_group("board")
@onready var move = $Move
@onready var move_target = $MoveTarget
@onready var animation_player = $AnimationPlayer
@onready var point_spawn = $PointSpawn

var queue: DataEventQueue
var state = MOVE
var merging := false
var multipler := 0

func _ready():
	point_spawn.timeout.connect(func():
		var point = point_scene.instantiate()
		point.global_position = global_position
		point.scale = scale
		point.multipler = multipler * merge_count
		spawn.emit(point)
	)
	mouse_event.pressed.connect(func(): clicked.emit())
	add_to_group(res.id)
	check_for_merge()

func check_for_merge():
	var same = get_tree().get_nodes_in_group(res.id).filter(func(c): return not c.merging and c.scale.x == scale.x)
	if same.size() >= merge_count:
		var count = 0
		for node in same:
			if count >= merge_count:
				break
			
			count += 1
			if node == self:
				node.merge_to(global_position, true)
				continue
			node.merge_to(global_position)

func merge_to(pos: Vector2, main = false):
	merging = true
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", pos, 0.5)
	tw.finished.connect(func():
		if main:
			multipler += 1
			scale *= merge_scale
			check_for_merge()
		else:
			queue_free()
		
		merging = false
	)

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
