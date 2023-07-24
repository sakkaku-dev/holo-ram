class_name GUI
extends Menu

@export var lose_screen: Control
@export var win_screen: Control
@export var game_screen: Control

func _ready():
	change_menu(game_screen)

func win():
	change_menu(win_screen)
	
func lose():
	change_menu(lose_screen)


func _on_back_pressed():
	GameManager.change_to_menu()

func _on_restart_pressed():
	get_tree().reload_current_scene()
