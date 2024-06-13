class_name Card
extends Node2D

signal summon_finished

@export var front: Sprite2D
@export var back: Sprite2D
@export var clickable: TextureButton

@export var debug = false

@onready var anim := $AnimationPlayer
@onready var back_cover = $BackCover

signal clicked()

var unfocus_color = Color(.8, .8, .8, 1)
var card = null : set = _set_card

# TODO: why not texture button?

func _ready():
	anim.play("RESET")
	hide_card()
	_on_clickable_mouse_exited()

func hide_card():
	hide()
	close()

func _set_card(c: CardResource):
	card = c
	visible = c != null
	back_cover.show()
	if card and debug:
		front.texture = card.profile
		back.modulate = card.border_color

func is_open():
	return front.visible

func open():
	if card:
		front.texture = card.profile
		back.modulate = card.border_color
		front.show()
		modulate = Color.WHITE
		clickable.hide()
	else:
		print("cannot open card without data")

func close():
	if not debug:
		back.modulate = Color.WHITE
	front.hide()
	clickable.show()
	modulate = unfocus_color
	_on_clickable_mouse_exited()

func disable():
	clickable.hide()


func enable():
	clickable.show()


func burn():
	anim.play("burn")


func burn_away():
	anim.play("burn_away")


func _on_clickable_pressed():
	clicked.emit()


func _on_clickable_mouse_entered():
	modulate = Color.WHITE


func _on_clickable_mouse_exited():
	modulate = unfocus_color

func summon():
	anim.play("summon")

func summon_finish():
	summon_finished.emit()
