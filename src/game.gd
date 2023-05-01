extends Node2D

@export var card_scene: PackedScene
@export var camera: Camera2D
@export var tilemap: TileMap
@export var cards: int

const TERRAIN_SET = 0
const TERRAIN = 0
const LAYER = 0
const BOARD_TILE = Vector2(1, 1)

@onready var tile_size = tilemap.tile_set.tile_size

func _ready():
	_init_board()

func _init_board():
	var total_cards = cards * 2
	var tile_size = tilemap.tile_set.tile_size
	var board_size = int(ceil(sqrt(total_cards)))
	
	var cells = []
	for x in range(-1, board_size + 1):
		for y in range(-1, board_size + 1):
			var coord = Vector2(x, y)
			cells.append(coord)
			
			if x >= 0 and y >= 0 and x < board_size and y < board_size:
				var card = card_scene.instantiate()
				tilemap.add_child(card)
				card.position = tilemap.map_to_local(coord)
	
	tilemap.set_cells_terrain_connect(LAYER, cells, TERRAIN_SET, TERRAIN)
	
	_center_camera(board_size)
	_zoom_camera_fit()

func _center_camera(board_size):
	var center = Vector2(floor(board_size / 2), floor(board_size / 2))
	var global_center = tilemap.map_to_local(center)
	if board_size % 2 == 0:
		global_center -= Vector2(tile_size) / 2
	camera.global_position = global_center

func _zoom_camera_fit():
	var map_size = tilemap.get_used_rect().size.y
	var global_size = map_size * tile_size.y
	var zoom = camera.get_viewport_rect().size.y / global_size
	camera.zoom = Vector2(zoom, zoom)
