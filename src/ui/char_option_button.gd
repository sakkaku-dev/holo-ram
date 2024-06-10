extends TextureButton

@export var label: Label
@export var tex: TextureRect

func set_char(card: CardResource):
	label.text = card.name
	
	var profile = card.get_profile()
	if profile:
		tex.texture = profile
