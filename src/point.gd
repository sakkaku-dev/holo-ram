extends Node2D

@onready var control = $Control
@onready var timer = $Timer

var multipler := 1

func _ready():
	timer.timeout.connect(func(): queue_free())
	control.mouse_entered.connect(func():
		GameManager.points += 1 * max(multipler, 1)
		queue_free()
	)
