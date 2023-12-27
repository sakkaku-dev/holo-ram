class_name CardSlot
extends PanelContainer

signal card_select()

@export var btn: TextureButton

var card: CardResource
var is_selected := false : set = _set_is_selected

func _ready():
	btn.pressed.connect(func():
		card_select.emit()
		self.is_selected = true
	)

func _set_is_selected(v: bool):
	is_selected = v
	modulate = Color.GRAY if v else Color.WHITE

func set_card(card: CardResource, changable = true):
	btn.texture_normal = card.profile
	btn.disabled = not changable
	self.card = card
