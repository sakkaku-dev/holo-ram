extends Control

signal cards_selected(cards)

@export var max_cards := 10

@export_category("Nodes")
@export var container: Control
@export var slot_card_select: Control
@export var card_slot_scene: PackedScene
@export var slot_drag_scene: PackedScene

@onready var effect_root = $EffectRoot

var level: LevelResource

func _ready():
	for i in range(max_cards):
		var slot = card_slot_scene.instantiate()
		container.add_child(slot)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		effect_root.reverse_effect()

func open_select(level: LevelResource):
	_add_cards_to_slots(level.cards)
	_create_card_selects(level.cards)
	effect_root.do_effect()
	self.level = level

func _add_cards_to_slots(cards: Array):
	for i in cards.size():
		var slot = container.get_child(i)
		var card = cards[i]
		slot.set_card(card, false)

func _create_card_selects(cards: Array):
	for c in slot_card_select.get_children():
		slot_card_select.remove_child(c)
	
	var level_cards = cards.map(func(x): return x.resource_path)
	for card_path in GameManager.get_unlocked_card_paths():
		if card_path in level_cards: continue
		
		var node = slot_drag_scene.instantiate()
		node.set_card(load(card_path))
		slot_card_select.add_child(node)

func _on_play_pressed():
	var selected_cards = container.get_children() \
		.map(func(c): return c.card) \
		.filter(func(c): return c != null)
	
	cards_selected.emit(selected_cards)
