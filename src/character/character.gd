class_name Character
extends CharacterBody2D

signal action_cooldown()

@export var speed := 50
@export var anim: AnimationPlayer
@export var sprite: Node2D
@export var timer: Timer

var dir = Vector2.UP

func _ready():
	dir = dir.rotated(TAU * randf())
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	timer.timeout.connect(_on_action_timeout)

func _on_action_timeout():
	action_cooldown.emit()

func _physics_process(delta):
	velocity = dir * speed
	
	sprite.scale.x = sign(dir.x)
	if anim.current_animation != "run":
		anim.play("run")
	
	if move_and_slide():
		var collision = get_last_slide_collision()
		if collision:
			dir = dir.bounce(collision.get_normal())

func do_action(board: Board):
	pass
