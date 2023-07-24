extends Node

@export var data_queue: DataEventQueue
@export var save_manager: SaveManager

var current_level_file = ""

var unlocked_cards = []
var unlocked_levels = []

func _ready():
	load_data()

func unlock_level():
	var level = load(current_level_file)
	var level_name = Util.filename(current_level_file)
	if not level_name in unlocked_levels:
		unlocked_levels.append(level_name)

	for card in level.cards:
		var file_name = Util.filename(card.resource_path)
		if not file_name in unlocked_cards:
			unlocked_cards.append(file_name)
	save_data()

func save_data():
	save_manager.save_to_slot(0, {
		"cards": unlocked_cards,
		"levels": unlocked_levels,
	})

func load_data():
	var data = save_manager.load_from_slot(0)
	if data:
		unlocked_cards = data["cards"]
		unlocked_levels = data["levels"]
