extends Control

const CARD_FOLDER = "res://src/cards/"

@export var grid: GridContainer
@export var texture: TextureRect
@export var name_label: Label
@export var text_label: Label

func _ready():
	_set_card_details(null, false)
	
	var unlocked = GameManager.get_unlocked_card_types()
	for type in CardResource.Type.values():
		var res = GameManager.get_card_resource(type)
		var tex = TextureRect.new()
		var is_unlocked = type in unlocked
		tex.texture = res.profile
		tex.modulate = Color.WHITE if is_unlocked else Color(0.05, 0.05, 0.05, 1.0)
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.mouse_entered.connect(func(): _on_mouse_enter(tex, res, is_unlocked))
		tex.mouse_exited.connect(func(): tex.z_index = 0)
		grid.add_child(tex)
	
func _on_mouse_enter(tex: TextureRect, card: CardResource, unlocked: bool):
	tex.z_index = 10
	_set_card_details(card, unlocked)

func _set_card_details(card: CardResource, unlocked: bool):
	if card:
		name_label.text = tr(card.name) if unlocked else ""
		text_label.text = tr(card.text) if unlocked else ""
		texture.texture = card.illust
		texture.modulate = Color.WHITE if unlocked else Color.BLACK
	else:
		name_label.text = ""
		text_label.text = ""
		texture.texture = null
