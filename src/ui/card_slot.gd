extends PanelContainer

signal card_select()

@export var btn: TextureButton

var card: CardResource

func _ready():
	btn.pressed.connect(func(): card_select.emit())

func set_card(card: CardResource, changable = true):
	btn.texture_normal = card.profile
	btn.disabled = not changable
	self.card = card
