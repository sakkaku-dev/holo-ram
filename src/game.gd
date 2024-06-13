extends Node2D

@export var option_container: Control
@export var option_scene: PackedScene
@export var root: Node2D
@export var result_label: Label
@export var room_scene: PackedScene

@export_category("Values")
@export var grid_col = 3
@export var screen_count := 9
@export var min_char := 3
@export var max_char := 5
@export var min_char_count := 15
@export var max_char_count := 20

@onready var camera_2d = $Camera2D
@onready var single_room = $SingleRoom

var valid_spawns := []

var spawned_pos = []
var valid_card: CardResource

#var card_count = 3
#var spawn_count = 5

var selected_grid := 0:
	set(v):
		if v < 0:
			#selected_grid = grid.size() - 1
			return
		elif v >= grid.size():
			#selected_grid = 0
			return
		
		selected_grid = v
		
		camera_2d.global_position = root.get_child(selected_grid).global_position

var grid := []

func _ready():
	pass
	
	#result_label.text = ""
	#
	#var groups = GameManager.get_card_groups()
	#var selected_groups = _pick_random_unique(groups, screen_count)
	#
	#for group in selected_groups:
		#var char_count = min(group.size(), randi_range(min_char, max_char))
		#var selected_chars = _pick_random_unique(group, char_count)
		#var total_char_count = randi_range(min_char_count, max_char_count)
		#var equal_count = floor(total_char_count / float(selected_chars.size()))
		#
		#var char_counts = {}
		#for c in selected_chars:
			#char_counts[c] = equal_count
		#
		## Random offset count
		#for i in range(3):
			#var change = _pick_random_unique(char_counts.keys(), 2)
			#var d = randi_range(-1, 1)
			#char_counts[change[0]] += d
			#char_counts[change[1]] -= d
		#
		## Fill remaining until total_char_count
		#var current_total = char_counts.values().reduce(func(a, b): return a + b, 0)
		#var delta = total_char_count - current_total
		#var current_idx = 0
		#while delta != 0:
			#var c = selected_chars[current_idx]
			#var change_by = sign(delta)
			#char_counts[c] += change_by
			#delta -= change_by
			#
			#current_idx += 1
			#if current_idx >= selected_chars.size():
				#current_idx = 0
		#
		## To array
		##var result = [];
		##for c in char_counts:
			##for i in char_counts[c]:
				##result.append(c)
		#
		#grid.append(char_counts)
	#
	#print(grid)
	#var current_row = 0
	#for i in grid.size():
		#var g = grid[i]
		#var room = room_scene.instantiate()
		#root.add_child(room)
#
		#var pos = Vector2(i % grid_col, current_row)
		#room.global_position = pos * Vector2(room.get_size())
		#room.add_characters(g)
#
		#if pos.x >= grid_col - 1:
			#current_row += 1
			#
	#self.selected_grid = 0

var spawned_cards := []

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		var card = GameManager.get_random_card(spawned_cards)
		if card:
			spawned_cards.append(card)
			single_room.add_clone(card)
	elif event.is_action_pressed("move_up"):
		var card = spawned_cards.pick_random()
		if card:
			single_room.add_clone(card)
		
	#if event.is_action_pressed("move_left"):
		#self.selected_grid -= 1
	#elif event.is_action_pressed("move_right"):
		#self.selected_grid += 1
	#elif event.is_action_pressed("move_up"):
		#self.selected_grid -= grid_col
	#elif event.is_action_pressed("move_down"):
		#self.selected_grid += grid_col

#func _on_select(char: CardResource):
	#if char == valid_card:
		#spawn_count += 1
		#if spawn_count % 5 == 0:
			#card_count += 1
		#_spawn_cards()
		#_show_result(true)
	#else:
		#_spawn_cards()
		#_show_result(false)

func _show_result(correct: bool):
	result_label.text = "Correct" if correct else "Wrong"

#func _spawn_cards():
	#for c in root.get_children():
		#root.remove_child(c)
	#spawned_pos = []
	#
	#valid_spawns = board.get_valid_spawns()
	#
	#var available = cards.duplicate()
	#var chars = _chars_for_group(available)
	#var spawned_chars = []
	#
	#valid_card = chars[1]
	#for char in chars[0]:
		#var res = char
		#var c = spawn_count
		#if char is Array:
			#res = char[0]
			#c = char[1]
		#
		#for node in _spawn_char_count(res, c):
			#node.clicked.connect(func(): _on_select(res))
		#spawned_chars.append(res)
	#
	#spawned_chars.shuffle()
	#_show_options(spawned_chars)

#func _show_options(char: Array):
	#for c in option_container.get_children():
		#option_container.remove_child(c)
	#
	#for c in char:
		#var opt = option_scene.instantiate()
		#opt.set_char(c)
		#opt.pressed.connect(func(): _on_select(c))
		#option_container.add_child(opt)

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

#func _chars_for_number(available_chars: Array) -> Array:
	#var chars = _pick_random_unique(available_chars, card_count)
	#var idx = randi_range(0, chars.size() - 1)
	#var valid = chars[idx]
	#chars[idx] = [valid, spawn_count - 1]
	#
	#return [chars, valid]
#
#func _chars_for_group(available_chars: Array) -> Array:
	#var chars = {}
	#
	#for char in available_chars:
		#if not char.group in chars:
			#chars[char.group] = []
		#chars[char.group].append(char)
	#
	#var large_enough_groups = chars.keys().filter(func(k): return chars[k].size() >= card_count - 1)
	#if large_enough_groups.is_empty():
		#return [[], null]
	#
	#var group = large_enough_groups.pick_random()
	#var group_chars = chars[group]
	#chars.erase(group)
	#
	#var odd_group = chars.keys().pick_random()
	#var char = chars[odd_group].pick_random()
	#
	#var result = _pick_random_unique(group_chars, card_count - 1)
	#result.append(char)
	#return [result, char]
