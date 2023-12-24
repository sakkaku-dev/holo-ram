class_name Move
extends Node

@export var body: CharacterBody2D
@export var speed := 50
@export var sprite: Node2D
@export var anim: AnimationPlayer

var dir = Vector2.UP

func _ready():
	dir = dir.rotated(TAU * randf())

func update(delta: float):
	if do_move(dir):
		var collision = body.get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			dir = dir.bounce(normal)

			# prevent too straight bounces
			if normal.dot(dir) >= 0.95:
				var diff_sign = -1 if normal.angle() > dir.angle() else 1
				dir = dir.rotated(diff_sign * PI/4) # TODO: range?

func do_move(d):
	body.velocity = d * speed
	
	sprite.scale.x = sign(d.x) # direction won't be zero, so it's fine
	if anim.current_animation != "run":
		anim.play("run")
	
	return body.move_and_slide()
