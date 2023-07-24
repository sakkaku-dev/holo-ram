extends Node

@export var data_queue: DataEventQueue

var current_level_file = ""

var unlocked_cards = []
var unlocked_levels = []

func unlock_level():
	var level = load(current_level_file)
	unlocked_levels.append(Util.filename(current_level_file))

	for card in level.cards:
		unlocked_cards.append(Util.filename(card.resource_path))
