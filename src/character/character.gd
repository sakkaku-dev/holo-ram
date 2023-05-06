class_name Character
extends CharacterBody2D

@export var speed := 200
@export var anim: AnimationPlayer
@export var sprite: Node2D

var dir = Vector2.UP

func _ready():
	dir = dir.rotated(TAU * randf())

func _physics_process(delta):
	velocity = dir * speed
	
	sprite.scale.x = sign(dir.x)
	if anim.current_animation != "run":
		anim.play("run")
	
	if move_and_slide():
		var collision = get_last_slide_collision()
		if collision:
			dir = dir.bounce(collision.get_normal())
