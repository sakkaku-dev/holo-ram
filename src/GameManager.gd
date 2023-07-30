extends Node

@export var max_cards_per_game := 30
@export var data_queue: DataEventQueue
@export var save_manager: SaveManager

var current_level_file = ""

var _card_type_map = {
	CardResource.Type.AME: "res://src/cards/Ame.tres",
	CardResource.Type.CALLI: "res://src/cards/Calli.tres",
	CardResource.Type.GURA: "res://src/cards/Gura.tres",
	CardResource.Type.INA: "res://src/cards/Ina.tres",
	CardResource.Type.KIARA: "res://src/cards/Kiara.tres",
	CardResource.Type.KORONE: "res://src/cards/Korone.tres",
	CardResource.Type.OKAYU: "res://src/cards/Okayu.tres",
	CardResource.Type.FUBUKI: "res://src/cards/Fubuki.tres",
	CardResource.Type.MIO: "res://src/cards/Mio.tres"
}
var _level_type_map = {
	LevelResource.Type.HOLOMYTH: "res://src/levels/HoloMyth.tres",
	LevelResource.Type.HOLOGAMERS: "res://src/levels/HoloGamers.tres"
}

var _unlocked_cards = []
var _unlocked_levels = []

func _ready():
	load_data()

func unlock_level():
	var level = load(current_level_file) as LevelResource
	var level_key = LevelResource.Type.keys()[level.type]
	if not level_key in _unlocked_levels:
		_unlocked_levels.append(level_key)

	for card in level.cards:
		var card_key = CardResource.Type.keys()[card.type]
		if not card_key in _unlocked_cards:
			_unlocked_cards.append(card_key)
	save_data()

func save_data():
	save_manager.save_to_slot(0, {
		"cards": _unlocked_cards,
		"levels": _unlocked_levels,
	})

func load_data():
	var data = save_manager.load_from_slot(0)
	if data:
		_unlocked_cards = data["cards"]
		_unlocked_levels = data["levels"]
		
func get_card_resource(type: int) -> CardResource:
	return load(_card_type_map[type])

func get_unlocked_cards():
	var result = []
	for type in get_unlocked_card_types():
		result.append(_card_type_map[type])
	return result

func get_unlocked_card_types():
	var types = []
	for c in _unlocked_cards:
		types.append(CardResource.Type[c])
	return types

func change_to_menu():
	get_tree().change_scene_to_file("res://src/ui/start.tscn")
