extends Control

const CARD_FOLDER = "res://src/cards/"

@export var grid: GridContainer
@export var texture: TextureRect
@export var name_label: Label
@export var text_label: Label

func _ready():
	_set_card_details(null)
	
	for card in GameManager.get_unlocked_cards():
		var res = load(card) as CardResource
		var tex = TextureRect.new()
		tex.texture = res.profile
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.mouse_entered.connect(func(): _on_mouse_enter(tex, res))
		tex.mouse_exited.connect(func(): tex.z_index = 0)
		grid.add_child(tex)
	
func _on_mouse_enter(tex: TextureRect, card: CardResource):
	tex.z_index = 10
	_set_card_details(card)

func _set_card_details(card: CardResource):
	if card:
		name_label.text = tr(card.name)
		text_label.text = tr(card.text)
		texture.texture = card.illust
	else:
		name_label.text = ""
		text_label.text = ""
		texture.texture = null
