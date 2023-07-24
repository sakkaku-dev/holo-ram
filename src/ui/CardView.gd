extends Control

const CARD_FOLDER = "res://src/cards/"

func _ready():
	for card in GameManager.unlocked_cards:
		var res = load(CARD_FOLDER + card) as CardResource
		var tex = TextureRect.new()
		tex.texture = res.profile
		tex.mouse_entered.connect(func(): tex.z_index = 10)
		tex.mouse_exited.connect(func(): tex.z_index = 0)
		add_child(tex)
	
