class_name ControlHighlight
extends Node

@export var control: Control
@export var inactive_color = Color(0.7, 0.7, 0.7)

@onready var ctrl = control if control else get_parent()

func _ready():
	ctrl.modulate = inactive_color
	ctrl.mouse_entered.connect(func(): ctrl.modulate = Color.WHITE)
	ctrl.mouse_exited.connect(func(): ctrl.modulate = inactive_color)
