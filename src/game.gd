extends Node2D

@export var board: Board
@export var action_timer: Timer
@export var countdown: Countdown
@export var gui: GUI
@export var option_container: Control
@export var option_scene: PackedScene
@export var root: Node2D
@export var result_label: Label

@export_category("Values")
@export var time_per_card := 2

@onready var queue = $DataEventQueue

var ready_characters: Array[Character] = []
var time_for_match := 0.0

var valid_spawns := []
var cards := []

var spawned_pos = []
var valid_card: CardResource

var card_count = 3
var spawn_count = 5

func _ready():
	result_label.text = ""
	cards = GameManager.get_cards_for_game()
	_spawn_cards()

func _on_select(char: CardResource):
	if char == valid_card:
		spawn_count += 1
		if spawn_count % 5 == 0:
			card_count += 1
		_spawn_cards()
		_show_result(true)
	else:
		_spawn_cards()
		_show_result(false)

func _show_result(correct: bool):
	result_label.text = "Correct" if correct else "Wrong"

func _spawn_cards():
	for c in root.get_children():
		root.remove_child(c)
	spawned_pos = []
	
	var board_size = int(floor(sqrt(card_count * spawn_count)))
	board.init_board(board_size)
	valid_spawns = board.get_valid_spawns()
	
	var available = cards.duplicate()
	var chars = _chars_for_group(available)
	var spawned_chars = []
	
	valid_card = chars[1]
	for char in chars[0]:
		var res = char
		var c = spawn_count
		if char is Array:
			res = char[0]
			c = char[1]
		
		for node in _spawn_char_count(res, c):
			node.clicked.connect(func(): _on_select(res))
		spawned_chars.append(res)
	
	spawned_chars.shuffle()
	_show_options(spawned_chars)

func _show_options(char: Array):
	for c in option_container.get_children():
		option_container.remove_child(c)
	
	for c in char:
		var opt = option_scene.instantiate()
		opt.set_char(c)
		opt.pressed.connect(func(): _on_select(c))
		option_container.add_child(opt)

func _spawn_char_count(card: CardResource, count: int):
	var scene = card.get_scene()
	if not scene:
		print("Scene not found for %s" % card.id)
		scene = load("res://src/cards/scenes/korone.tscn")
	
	var available_pos = valid_spawns.filter(func(p): return not p in spawned_pos)
	var nodes = []
	for y in range(count):
		var c = scene.instantiate()
		root.add_child(c)
		nodes.append(c)
		
		var pos = Vector2.ZERO
		if available_pos.is_empty():
			pos = valid_spawns.pick_random()
		else:
			pos = available_pos.pick_random()
		c.global_position = board.map_to_local(pos)
	return nodes

func _pick_random_unique(arr: Array, count: int):
	var items = arr.duplicate()
	var result = []
	for i in count:
		if items.is_empty():
			print("Array not enough items to get %s items: %s" % [count, arr])
			break
		
		var item = items.pick_random()
		items.erase(item)
		result.append(item)
	
	return result

func _chars_for_number(available_chars: Array) -> Array:
	var chars = _pick_random_unique(available_chars, card_count)
	var idx = randi_range(0, chars.size() - 1)
	var valid = chars[idx]
	chars[idx] = [valid, spawn_count - 1]
	
	return [chars, valid]

func _chars_for_group(available_chars: Array) -> Array:
	var chars = {}
	
	for char in available_chars:
		if not char.group in chars:
			chars[char.group] = []
		chars[char.group].append(char)
	
	var large_enough_groups = chars.keys().filter(func(k): return chars[k].size() >= card_count - 1)
	if large_enough_groups.is_empty():
		return [[], null]
	
	var group = large_enough_groups.pick_random()
	var group_chars = chars[group]
	chars.erase(group)
	
	var odd_group = chars.keys().pick_random()
	var char = chars[odd_group].pick_random()
	
	var result = _pick_random_unique(group_chars, card_count - 1)
	result.append(char)
	return [result, char]
