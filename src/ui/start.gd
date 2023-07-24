extends Menu

@export var level_select: Control
@export var card_view: Control

func _ready():
	change_menu(level_select)

func _on_card_view_pressed():
	change_menu(card_view)