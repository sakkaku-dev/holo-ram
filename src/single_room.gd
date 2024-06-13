extends Node2D

@export var board: Board

var valid_spawns := []

func _ready():
	valid_spawns = board.get_valid_spawns()

func add_clone(char: CardResource):
	_spawn_char_count(char, 1)
	GameManager.clones += 1

func _spawn_char_count(card: CardResource, count: int):
	var scene = card.get_scene()
	if not scene:
		print("Scene not found for %s" % card.id)
		scene = load("res://src/cards/scenes/korone.tscn")
	
	var available_pos = valid_spawns
	var nodes = []
	for y in range(count):
		var c = scene.instantiate()
		c.res = card
		c.spawn.connect(func(p): add_child(p))
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
	return (board.get_used_rect().size + Vector2i(5, 5)) * board.tile_set.tile_size
