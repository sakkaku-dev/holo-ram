class_name Character
extends CharacterBody2D

signal action_cooldown()
signal action_finished()

enum {
	MOVE,
	MOVE_TARGET,
	ACTION,
}

@export var speed := 50
@export var anim: AnimationPlayer
@export var sprite: Node2D
@export var action_cooldown_time := 5.0

@export var move_to_closest := false
@export var move_closest_available := false
@export var finish_on_action := true

@onready var board: Board = get_tree().get_first_node_in_group("board")

var queue: DataEventQueue 

var dir = Vector2.UP
var target_pos = null : set = _set_target_pos
var state = MOVE

var coord: Vector2
var closest_available: Vector2

func _set_target_pos(v):
	target_pos = v
	if target_pos != null:
		state = MOVE_TARGET

func _ready():
	dir = dir.rotated(TAU * randf())
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	if not anim.has_animation("action"):
		anim.get_animation_library("").add_animation("action", Animation.new())
	if not anim.has_animation("run"):
		anim.get_animation_library("").add_animation("run", Animation.new())

	anim.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim_name: String):
	if anim_name == "action" and finish_on_action:
		finish_action()

func finish_action():
	action_finished.emit()
	target_pos = null
	get_tree().create_timer(action_cooldown_time).timeout.connect(func(): action_cooldown.emit())
	state = MOVE

func _physics_process(_delta):
	match state:
		MOVE: _move()
		MOVE_TARGET: _move_target()
	

func _move():
	if _do_move(dir):
		var collision = get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			dir = dir.bounce(normal)

			# prevent too straight bounces
			if normal.dot(dir) >= 0.95:
				var diff_sign = -1 if normal.angle() > dir.angle() else 1
				dir = dir.rotated(diff_sign * PI/4) # TODO: range?

func _move_target():
	if target_pos != null:
		var dist = global_position.distance_to(target_pos)
		if dist < 5:
			_action()
		else:
			_do_move(global_position.direction_to(target_pos))
	else:
		_action()

func _do_move(d):
	velocity = d * speed
	
	sprite.scale.x = sign(d.x) # direction won't be zero, so it's fine
	if anim.current_animation != "run":
		anim.play("run")
	
	return move_and_slide()

func _action():
	state = ACTION
	anim.play("action")
	_create_event()

func _create_event():
	pass
	
func do_action():
	if move_to_closest:
		coord = Vector2(board.get_coord_for(global_position))
		if move_closest_available:
			closest_available = queue.get_data().get_closest_card_coord(coord, dir)
			if closest_available:
				self.target_pos = board.get_global_position_for(closest_available)
		else:
			self.target_pos = board.get_global_position_for(coord)
	else:
		target_pos = global_position
