class_name Board
extends TileMap

signal selected(coord1, coord2)

const TERRAIN_SET = 0
const TERRAIN = 0
const LAYER = 0
const BOARD_TILE = Vector2(1, 1)

@export var card_scene: PackedScene
@export var camera: BoardCamera

var current_select = null
var card_nodes = {}
var opened = false

func get_coord_for(pos: Vector2):
	return local_to_map(pos)

func get_global_position_for(coord: Vector2):
	return map_to_local(coord)


func hide_card(coord: Vector2):
	if coord in card_nodes:
		card_nodes[coord].hide_card()
		if coord == current_select:
			current_select = null

func close_cards():
	for coord in card_nodes:
		card_nodes[coord].close()
	opened = false
	current_select = null

func init_board(size):
	_create_board_tiles(size)
	camera.update(size)

func _create_board_tiles(board_size: int):
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

func update_card_data(data: DataSnapshot):
	for coord in card_nodes:
		var card_node = card_nodes[coord]
		card_node.card = data.get_card(coord)

func _on_card_click(card_node: Card, coord: Vector2):
	if opened: return
	
	card_node.open()
	
	if current_select == null:
		current_select = coord
	else:
		selected.emit(current_select, coord)
		opened = true

func _get_card_node(coord: Vector2):
	if coord in card_nodes:
		return card_nodes[coord]
	return null
