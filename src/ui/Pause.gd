extends Control

func _ready():
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			show()
			get_tree().paused = true


func _on_resume_pressed():
	hide()
	get_tree().paused = false


func _on_back_pressed():
	GameManager.change_to_menu()

func _exit_tree():
	get_tree().paused = false
