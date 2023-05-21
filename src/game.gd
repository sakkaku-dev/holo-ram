extends Node2D

@export var level: LevelResource
@export var board: Board

func _ready():
	board.init_board(level.cards)
	board.matched.connect(_spawn_card)
	board.all_matched.connect(_win)

func _win():
	print("You win")

func _spawn_card(card: CardResource, pos: Vector2):
	var scene = card.character
	if scene:
		var char = scene.instantiate() as Node2D
		char.global_position = pos
		get_tree().current_scene.add_child(char)
	else:
		print("missing scene for " % card)
