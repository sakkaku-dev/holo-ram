extends Node2D

const TERRAIN_SET = 0
const TERRAIN = 0
const LAYER = 0
const BOARD_TILE = Vector2(1, 1)

@export var card_scene: PackedScene
@export var level: LevelResource

@export var camera: BoardCamera
@export var tilemap: TileMap

var handle_click = false
var selected: Array[Vector2] = []
var data: Array[Array] = []
var card_nodes = {}

func _ready():
	_init_board(level.cards)

func _init_board(cards: Array[CardResource]):
	data = _create_board_data(cards)
	_create_board_tiles(data)
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
				var card_data = _get_card(coord, board)
				if card_data:
					var card = card_scene.instantiate() as Card
					card.card = card_data
					card.position = tilemap.map_to_local(coord)
					card.clicked.connect(func(): _on_card_click(card, coord))
					tilemap.add_child(card)
					card_nodes[coord] = card
	
	tilemap.set_cells_terrain_connect(LAYER, cells, TERRAIN_SET, TERRAIN)

func _on_card_click(card: Card, coord: Vector2):
	if handle_click:
		return
	
	handle_click = true
	card.open()
	
	if selected.size() == 0:
		selected.append(coord)
	else:
		var prev_card = _get_card(selected[0])
		var prev_card_node = _get_card_node(selected[0])
		
		await get_tree().create_timer(1).timeout
		
		if card.card == prev_card:
			print("Match")
			card.queue_free()
			prev_card_node.queue_free()
			
			if data.size() == 0:
				_win()
		else:
			prev_card_node.close()
			card.close()
		
		selected.clear()
	
	handle_click = false

func _get_card(coord: Vector2, d = data):
	return d[coord.y][coord.x]

func _get_card_node(coord: Vector2):
	return card_nodes[coord]

func _win():
	print("You win")
