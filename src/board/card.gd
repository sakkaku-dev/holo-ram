class_name Card
extends Node2D

@export var front: Sprite2D
@export var back: Sprite2D
@export var clickable: TextureButton

signal clicked()

var unfocus_color = Color(.8, .8, .8, 1)
var card = null : set = _set_card

func _ready():
	hide_card()
	_on_clickable_mouse_exited()

func hide_card():
	hide()
	close()

func _set_card(c: CardResource):
	card = c
	visible = c != null

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
	back.modulate = Color.WHITE
	front.hide()
	clickable.show()
	modulate = unfocus_color
	_on_clickable_mouse_exited()

func disable():
	clickable.hide()


func enable():
	clickable.show()


func _on_clickable_pressed():
	clicked.emit()


func _on_clickable_mouse_entered():
	modulate = Color.WHITE


func _on_clickable_mouse_exited():
	modulate = unfocus_color
