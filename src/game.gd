extends Node2D

@export var board: Board
@export var action_timer: Timer
@export var countdown: Countdown
@export var gui: GUI

@onready var data: DataEventQueue = GameManager.data_queue

var ready_characters: Array[Character] = []

func _ready():
	var level = load(GameManager.current_level_file)
	data.init_data(level.cards)
	board.init_board(data.size)
	board.update_card_data(data.current_data)
	
	data.cleared.connect(_win)
	data.updated.connect(func(): board.update_card_data(data.current_data))

	countdown.start_timer(level.cards.size() * 60)
	countdown.timeout.connect(_lose)

	# action_timer.connect("timeout", _do_action)

func _win():
	gui.win()
	GameManager.unlock_level()

func _lose():
	gui.lose()

# func _do_action():
# 	# TODO: keep list of next characters
# 	if ready_characters.size() > 0:
# 		print("Picking random char for action")
# 		if data.is_locked:
# 			print("Waiting for lock")
# 			await data.unlocked
# 		var char = ready_characters.pick_random() as Character
# 		ready_characters.erase(char)
# 		char.action_cooldown.connect(func(): ready_characters.append(char))
# 		char.do_action(data)
# 		await char.action_finished
# 		print("Action finished")
# 	else:
# 		print("Action ready but no characters")
# 	action_timer.start()

func _on_board_selected(coord1, coord2):
	# TODO: lock?
	await get_tree().create_timer(1).timeout

	var ev = MatchEvent.new(coord1, coord2)
	ev.matched.connect(func(card): _spawn_card_character(card, board.get_global_position_for(coord1)))
	data.do_event(ev)

	board.close_cards()


func _spawn_card_character(card: CardResource, pos: Vector2):
	var scene = card.character
	if scene:
		var node = scene.instantiate() as Node2D
		ready_characters.append(node)
		node.global_position = pos
		get_tree().current_scene.add_child(node)
	else:
		print("missing scene for " % card)
