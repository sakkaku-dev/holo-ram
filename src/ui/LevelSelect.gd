extends Control

signal select_cards(lvl)

const LEVELS_DIR = "res://src/levels"

@export var preview_scene: PackedScene
@export var container: Control

func _ready():
	show()
	
	var levels = Array(DirAccess.get_files_at(LEVELS_DIR)) \
		.filter(func(x): return x.ends_with(".tres")) \
		.map(func(x): return load("%s/%s" % [LEVELS_DIR, x]))

	for level in levels:
		var btn = TextureButton.new()
		btn.texture_normal = level.cover
		
		var preview = preview_scene.instantiate()
		preview.level = level
		preview.hide()
		
		btn.pressed.connect(func(): _load_level(level))
		btn.add_child(preview)
		btn.add_child(ControlHighlight.new())
		container.add_child(btn)

func _load_level(level: LevelResource):
	select_cards.emit(level)
