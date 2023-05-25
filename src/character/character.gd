class_name Character
extends CharacterBody2D

signal action_cooldown()
signal action_start()
signal action_finished()

@export var speed := 50
@export var anim: AnimationPlayer
@export var sprite: Node2D
@export var action_cooldown_time := 5.0

@onready var board: Board = get_tree().get_first_node_in_group("board")

var dir = Vector2.UP
var target_pos = null

func _ready():
	dir = dir.rotated(TAU * randf())
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	if not anim.has_animation("action"):
		anim.get_animation_library("").add_animation("action", Animation.new())
	if not anim.has_animation("move"):
		anim.get_animation_library("").add_animation("move", Animation.new())

func _on_action_timeout():
	action_cooldown.emit()

func _physics_process(delta):
	if target_pos:
		var dist = global_position.distance_to(target_pos)
		if dist < 5:
			action_start.emit()
			anim.play("action")
			await anim.animation_finished
			action_finished.emit()
			velocity = Vector2.ZERO
			target_pos = null
			get_tree().create_timer(action_cooldown_time).timeout.connect(_on_action_timeout)
		else:
			velocity = global_position.direction_to(target_pos) * speed
	else:
		velocity = dir * speed
	
	sprite.scale.x = sign(dir.x)
	if anim.current_animation != "run":
		anim.play("run")
	
	if move_and_slide():
		var collision = get_last_slide_collision()
		if collision:
			dir = dir.bounce(collision.get_normal())

func do_action(data: DataEventQueue):
	print("No action defined")
	target_pos = global_position

