extends Control

@export var container: Control

func _ready():
	var packs = GameManager.get_unlocked_packs()
	hide()
	
	if packs.size() == 0: return
	
	var added_pack = false
	for pack_path in packs.keys():
		var count = packs[pack_path]
		if count == 0: continue
		
		var pack = load(pack_path) as LevelResource
		
		var tex = TextureRect.new()
		tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.texture = pack.cover
		tex.custom_minimum_size = Vector2(0, 150)
		container.add_child(tex)
		added_pack = true
	
	visible = added_pack

func _on_pack_button_pressed():
	var cards = GameManager.unlock_packs() as Array[CardResource]
	if cards.is_empty():
		hide()
	
	for c in container.get_children():
		container.remove_child(c)
	
	for card in cards:
		var tex = TextureRect.new()
		tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.texture = card.profile
		tex.custom_minimum_size = Vector2(0, 150)
		container.add_child(tex)
	
