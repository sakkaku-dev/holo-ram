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

var selected_slot = null
var selected_card = null

func _ready():
	hide()
	for i in range(max_cards):
		var slot = card_slot_scene.instantiate()
		container.add_child(slot)
		slot.card_select.connect(func(): _on_slot_card_select(slot))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		effect_root.reverse_effect()

func _on_slot_card_select(slot: CardSlot):
	_unselect_slots()
	selected_slot = slot
	if selected_card == null:
		return
	
	_swap_cards(selected_slot, selected_card)

func _on_unlocked_card_select(unlocked_card: SlotCardDrag):
	_unselect_unlocked_cards()
	selected_card = unlocked_card
	if selected_slot == null:
		return
	
	_swap_cards(selected_slot, selected_card)

func _swap_cards(slot: CardSlot, unlocked_card: SlotCardDrag):
	var index = unlocked_card.get_index()
	var old_card = slot.card
	
	slot.set_card(unlocked_card.card)
	slot_card_select.remove_child(unlocked_card)

	if old_card:
		var node = _create_unlocked_card_select(old_card)
		slot_card_select.move_child(node, index)
		
	_unselect_slots()
	_unselect_unlocked_cards()

func _get_selected_unlocked_id():
	for i in slot_card_select.get_child_count():
		var child = slot_card_select.get_child(i)
		if child.is_selected:
			return i
	return -1

func _get_selected_slot_id():
	for i in container.get_child_count():
		var child = container.get_child(i)
		if child.is_selected:
			return i
	return -1

func _unselect_unlocked_cards():
	for c in slot_card_select.get_children():
		c.is_selected = false
	selected_card = null
	
func _unselect_slots():
	for c in container.get_children():
		c.is_selected = false
	selected_slot = null

func open_select(level: LevelResource):
	show()
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
		_create_unlocked_card_select(load(card_path))

func _create_unlocked_card_select(card: CardResource):
	var node = slot_drag_scene.instantiate()
	node.set_card(card)
	node.card_select.connect(func(): _on_unlocked_card_select(node))
	slot_card_select.add_child(node)
	return node

func _on_play_pressed():
	var selected_cards = container.get_children() \
		.map(func(c): return c.card) \
		.filter(func(c): return c != null)
	
	cards_selected.emit(selected_cards)
