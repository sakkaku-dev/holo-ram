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

@onready var board: Board = get_tree().get_first_node_in_group("board")

var dir = Vector2.UP
var target_pos = null : set = _set_target_pos
var state = MOVE

func _set_target_pos(v):
	target_pos = v
	if target_pos != null:
		state = MOVE_TARGET

func _ready():
	dir = dir.rotated(TAU * randf())
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	if not anim.has_animation("action"):
		anim.get_animation_library("").add_animation("action", Animation.new())
	if not anim.has_animation("move"):
		anim.get_animation_library("").add_animation("move", Animation.new())

	anim.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim: String):
	if anim == "action":
		action_finished.emit()
		target_pos = null
		get_tree().create_timer(action_cooldown_time).timeout.connect(func(): action_cooldown.emit())
		state = MOVE

func _physics_process(delta):
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
			if normal.dot(dir) >= 0.8:
				var diff_sign = -1 if normal.angle() > dir.angle() else 1
				dir = dir.rotated(PI/4) # TODO: range?

func _move_target():
	if target_pos != null:
		var dist = global_position.distance_to(target_pos)
		if dist < 5:
			state = ACTION
			_action()
		else:
			_do_move(global_position.direction_to(target_pos))
	else:
		_action()

func _do_move(d):
	velocity = d * speed
	
	sprite.scale.x = sign(d.x)
	if anim.current_animation != "run":
		anim.play("run")
	
	return move_and_slide()

func _action():
	state = ACTION
	anim.play("action")
	
func do_action(data: DataEventQueue):
	print("No action defined")
	target_pos = global_position
