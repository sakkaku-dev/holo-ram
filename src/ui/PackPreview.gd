extends Control

@export var name_label: Label
@export var container: Control

var level: LevelResource

func _ready():
	name_label.text = level.name
	for card in level.cards:
		var tex = TextureRect.new()
		tex.texture = card.profile
		container.add_child(tex)

	position.y = -size.y - 10
