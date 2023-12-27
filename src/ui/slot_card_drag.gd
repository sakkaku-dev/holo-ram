class_name SlotCardDrag
extends TextureButton

signal card_select()

var card: CardResource
var is_selected := false : set = _set_is_selected

func _ready():
	button_up.connect(func():
		card_select.emit()
		self.is_selected = true
	)

func _set_is_selected(v: bool):
	is_selected = v
	modulate = Color.GRAY if v else Color.WHITE

func set_card(card: CardResource):
	texture_normal = card.profile
	self.card = card

