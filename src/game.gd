extends Node2D

@export var board: Board
@export var action_timer: Timer
@export var countdown: Countdown
@export var gui: GUI

@export_category("Values")
@export var time_per_card := 2

@onready var queue = $DataEventQueue

var ready_characters: Array[Character] = []
var time_for_match := 0.0

func _ready():
	var cards = GameManager.get_cards_for_game()
	queue.init_data(cards)
	board.init_board(queue.size)
	board.update_card_data(queue.get_data())
	
	queue.cleared.connect(_win)
	queue.updated.connect(func(): board.update_card_data(queue.get_data()))

	time_for_match = cards.size() * time_per_card
	countdown.start_timer(cards.size() * time_per_card)
	countdown.timeout.connect(_lose)

	action_timer.connect("timeout", _do_action)

func _win():
	gui.win()
	GameManager.unlock_level()

func _lose():
	gui.lose()

func _do_action():
	if ready_characters.size() > 0:
		print("Picking random char for action")
		var c = ready_characters.pick_random() as Character
		ready_characters.erase(c)
		c.action_cooldown.connect(func(): ready_characters.append(c))
		c.do_action()
	else:
		print("Action ready but no characters")

func _on_board_selected(coord1, coord2):
	var ev = MatchEvent.new(coord1, coord2)
	ev.matched.connect(func(card): _on_matched(card, coord1))
	ev.wrong_match.connect(func(): board.close_cards())
	queue.do_event(ev, get_tree().create_timer(1.0).timeout)

func _on_matched(card: CardResource, coord: Vector2):
	countdown.add_time(time_for_match)
	_spawn_card_character(card, board.get_global_position_for(coord))

func _spawn_card_character(card: CardResource, pos: Vector2):
	var scene = card.character
	if scene:
		var node = scene.instantiate() as Node2D
		ready_characters.append(node)
		node.global_position = pos
		node.queue = queue
		get_tree().current_scene.add_child(node)
	else:
		print("missing scene for " % card)
	
	board.close_cards()


func _on_data_event_queue_locked():
	board.disable_cards()
