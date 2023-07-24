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
	unlocked_levels.append(Util.filename(current_level_file))

	for card in level.cards:
		unlocked_cards.append(Util.filename(card.resource_path))
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
