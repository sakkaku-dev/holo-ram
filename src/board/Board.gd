class_name Board
extends TileMap

signal all_matched()
signal matched(card, pos)

const TERRAIN_SET = 0
const TERRAIN = 0
const LAYER = 0
const BOARD_TILE = Vector2(1, 1)

@export var card_scene: PackedScene
@export var camera: BoardCamera

var handle_click = false
var selected: Array[Vector2] = []
var data: Array[Array] = []
var card_nodes = {}

func get_position_in_front(pos: Vector2, dir: Vector2):
	# TODO: find best position
	var coords = local_to_map(pos)
	return map_to_local(coords)

func init_board(cards: Array[CardResource]):
	data = _create_board_data(cards)
	_create_board_tiles(data)
	_update_card_node_data()
	camera.update(data.size())

func _create_board_data(cards: Array[CardResource]) -> Array[Array]:
	var total_cards = cards.size() * 2
	var board_size = int(ceil(sqrt(total_cards)))
	var data: Array[Array] = []
	
	var random_cards = cards.duplicate()
	random_cards.append_array(cards.duplicate())
	random_cards.shuffle()
	
	for row in range(0, board_size):
		var row_data = []
		for col in range(0, board_size):
			row_data.append(random_cards.pop_front())
		data.append(row_data)
	
	return data

func _create_board_tiles(board: Array[Array]):
	var board_size = board.size()
	var cells = []
	for y in range(-1, board_size + 1):
		for x in range(-1, board_size + 1):
			var coord = Vector2(x, y)
			cells.append(coord)
			
			if x >= 0 and y >= 0 and x < board_size and y < board_size:
				var card = card_scene.instantiate() as Card
				card.position = map_to_local(coord)
				card.clicked.connect(func(): _on_card_click(card, coord))
				add_child(card)
				card_nodes[coord] = card
	
	set_cells_terrain_connect(LAYER, cells, TERRAIN_SET, TERRAIN)

func _update_card_node_data(coords: Array[Vector2] = []):
	var keys = coords if coords.size() > 0 else card_nodes.keys()
	
	for coord in keys:
		var card_node = card_nodes[coord]
		card_node.card = _get_card(coord)

func _on_card_click(card_node: Card, coord: Vector2):
	if handle_click:
		return
	
	handle_click = true
	card_node.open()
	
	if selected.size() == 0:
		selected.append(coord)
	else:
		var prev_coord = selected[0]
		var card = _get_card(coord)
		var prev_card = _get_card(prev_coord)
		
		await get_tree().create_timer(1).timeout
		
		if card == prev_card:
			matched.emit(card, card_node.global_position)
			_set_card(coord, null)
			_set_card(prev_coord, null)
			_update_card_node_data([coord, prev_coord])
			
			if _card_count(1) == 0:
				all_matched.emit()
		else:
			var prev_card_node = _get_card_node(prev_coord)
			prev_card_node.close()
			card_node.close()
		
		selected.clear()
	
	handle_click = false

func _card_count(max_count = -1):
	var count = 0
	for i in range(data.size()):
		for j in range(data[i].size()):
			if data[i][j] != null:
				count += 1
				if max_count != -1 and count >= max_count:
					break
	return count

func _set_card(coord: Vector2, v):
	data[coord.y][coord.x] = v

func _get_card(coord: Vector2):
	return data[coord.y][coord.x]

func _get_card_node(coord: Vector2):
	return card_nodes[coord]
