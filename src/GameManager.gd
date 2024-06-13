extends Node

signal unlocked_cards()

@export var max_cards_per_game := 50
@export var save_manager: SaveManager

const _card_type_map = {
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
const _level_type_map = {
	LevelResource.Type.HOLOMYTH: "res://src/levels/HoloMyth.tres",
	LevelResource.Type.HOLOGAMERS: "res://src/levels/HoloGamers.tres"
}

var _unlocked_cards = []
var _current_level_file = ""
var _cards := []
var _unlocked_packs := {}

func _ready():
	TraceSubscriber.new().init()
	load_data()

func start_game(lvl: LevelResource, cards: Array):
	_current_level_file = lvl.resource_path
	_cards = cards
	get_tree().change_scene_to_file("res://src/game.tscn")

func get_cards_for_game():
	return _card_type_map.values().map(func(p): return load(p))

func get_unlocked_packs() -> Dictionary:
	return _unlocked_packs

func unlock_packs():
	if _unlocked_packs.is_empty():
		return []

	var unlocked = []
	for pack_path in _unlocked_packs:
		var count = _unlocked_packs[pack_path]
		var pack = load(pack_path)
		for _i in range(count):
			unlocked.append(_unlock_single_pack(pack))
	_unlocked_packs = {}

	unlocked_cards.emit()
	save_data()
	return unlocked

func _unlock_single_pack(pack: LevelResource):
	var card = pack.cards.pick_random() # TODO: improve it for the user
	var card_key = CardResource.Type.keys()[card.type]
	if not card_key in _unlocked_cards:
		_unlocked_cards.append(card_key)
	return card

func unlock_level():
	if not _current_level_file in _unlocked_packs:
		_unlocked_packs[_current_level_file] = 0
	
	_unlocked_packs[_current_level_file] += 1 # TODO: get more if more difficult
	save_data()

func save_data():
	save_manager.save_to_slot(0, {
		"cards": _unlocked_cards,
		"packs": _unlocked_packs,
	})

func load_data():
	var data = save_manager.load_from_slot(0)
	if not data:
		return
		
	if "cards" in data:
		_unlocked_cards = data["cards"]
	
	if "packs" in data:
		_unlocked_packs = data["packs"]

func get_card_resource(type: int) -> CardResource:
	return load(_card_type_map[type])

func get_unlocked_card_paths():
	var result = []
	for type in get_unlocked_card_types():
		result.append(_card_type_map[type])
	return result

func get_unlocked_card_types():
	var types = []
	for c in _unlocked_cards:
		types.append(CardResource.Type[c])
	return types

func is_card_type_unlocked(type):
	return type in get_unlocked_card_types()

func change_to_menu():
	get_tree().change_scene_to_file("res://src/ui/start.tscn")
