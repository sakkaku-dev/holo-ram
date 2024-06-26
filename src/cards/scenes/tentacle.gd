class_name Tentacle
extends Node2D

signal finished()

@export var anim: AnimationPlayer
@export var body: Node2D

func _ready():
	anim.animation_finished.connect(_anim_finished)

func _anim_finished(_n):
	finished.emit()
	queue_free()

func move(dir: Vector2, move_dir: Vector2):
	var cross = dir.cross(move_dir)
	var move_rot = rad_to_deg(dir.angle_to(move_dir))
	rotation = Vector2.RIGHT.angle_to(dir)
	
	if cross != 0:
		body.scale.y = -cross
	
	anim.play("move" if cross != 0 else "opposite")
