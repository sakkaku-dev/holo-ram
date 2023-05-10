class_name Card
extends Node2D

@export var card: CardResource
@export var front: Sprite2D
@export var back: Sprite2D
@export var clickable: TextureButton

signal clicked()

var unfocus_color = Color(.8, .8, .8, 1)

func _ready():
	if card:
		front.texture = card.profile
	
	close()
	_on_clickable_mouse_exited()


func open():
	back.modulate = card.border_color
	front.show()
	clickable.hide()


func close():
	back.modulate = Color.WHITE
	front.hide()
	clickable.show()
	_on_clickable_mouse_exited()


func _on_clickable_pressed():
	clicked.emit()


func _on_clickable_mouse_entered():
	modulate = Color.WHITE


func _on_clickable_mouse_exited():
	modulate = unfocus_color
