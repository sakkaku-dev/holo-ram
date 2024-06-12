extends Node2D

@export var board: Board

var valid_spawns := []
var spawned_pos := []

func _ready():
	valid_spawns = board.get_valid_spawns()

func add_characters(char_counts: Dictionary):
	for c in char_counts:
		_spawn_char_count(GameManager.get_card(c), char_counts[c])

func _spawn_char_count(card: CardResource, count: int):
	var scene = card.get_scene()
	if not scene:
		print("Scene not found for %s" % card.id)
		scene = load("res://src/cards/scenes/korone.tscn")
	
	var available_pos = valid_spawns.filter(func(p): return not p in spawned_pos)
	var nodes = []
	for y in range(count):
		var c = scene.instantiate()
		add_child(c)
		nodes.append(c)
		
		var pos = Vector2.ZERO
		if available_pos.is_empty():
			pos = valid_spawns.pick_random()
		else:
			pos = available_pos.pick_random()
		c.global_position = global_position + board.map_to_local(pos)
	return nodes

func get_size():
	return board.get_used_rect().size * board.tile_set.tile_size
