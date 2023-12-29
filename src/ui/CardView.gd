extends Control

const CARD_FOLDER = "res://src/cards/"

@export var grid: GridContainer
@export var card_view_tex: TextureRect
@export var name_label: Label
@export var text_label: Label

func _ready():
	position.x = -size.x
	show()
	_set_card_details(null, false)
	
	GameManager.unlocked_cards.connect(func():
		var unlocked = GameManager.get_unlocked_card_types()
		for child in grid.get_children():
			if not child.has_meta("type"): continue
			
			var type = child.get_meta("type")
			var is_unlocked = type in unlocked
			child.modulate = Color.WHITE if is_unlocked else Color(0.05, 0.05, 0.05, 1.0)
	)
	
	for type in CardResource.Type.values():
		var res = GameManager.get_card_resource(type)
		var tex = TextureRect.new()
		tex.texture = res.profile
		tex.set_meta("type", type)
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.mouse_entered.connect(func(): _on_mouse_enter(tex, res, GameManager.is_card_type_unlocked(type)))
		grid.add_child(tex)

func _on_mouse_enter(tex: TextureRect, card: CardResource, unlocked: bool):
	_set_card_details(card, unlocked)

func _set_card_details(card: CardResource, unlocked: bool):
	if card:
		name_label.text = tr(card.name) if unlocked else ""
		text_label.text = tr(card.text) if unlocked else ""
		card_view_tex.texture = card.illust
		card_view_tex.modulate = Color.WHITE if unlocked else Color.BLACK
	else:
		name_label.text = ""
		text_label.text = ""
		card_view_tex.texture = null
