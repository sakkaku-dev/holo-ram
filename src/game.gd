extends Node2D

@export var level: LevelResource
@export var board: Board
@export var action_timer: Timer
@export var countdown: Countdown
@export var gui: GUI

var ready_characters: Array[Character] = []

func _ready():
	board.init_board(level.cards)
	board.matched.connect(_spawn_card)
	board.all_matched.connect(func(): gui.win())
	
	countdown.start_timer(level.cards.size() * 60)
	countdown.timeout.connect(func(): gui.lose())
	
	action_timer.timeout.connect(_do_action)

func _do_action():
	# TODO: keep list of next characters
	if ready_characters.size() > 0:
		var char = ready_characters.pick_random() as Character
		ready_characters.erase(char)
		char.action_cooldown.connect(func(): ready_characters.append(char))
		await char.do_action(board)
	action_timer.start()

func _spawn_card(card: CardResource, pos: Vector2):
	var scene = card.character
	if scene:
		var char = scene.instantiate() as Node2D
		ready_characters.append(char)
		char.global_position = pos
		get_tree().current_scene.add_child(char)
	else:
		print("missing scene for " % card)
