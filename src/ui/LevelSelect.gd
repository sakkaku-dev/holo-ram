extends Control

const LEVELS_DIR = "res://src/levels"

@export var preview_scene: PackedScene
@export var container: Control

func _ready():
	var dir = DirAccess.open(LEVELS_DIR)
	var levels = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				levels.append(file_name)
			file_name = dir.get_next()

	for level in levels:
		var path = "%s/%s" % [LEVELS_DIR, level]
		var res = load(path)

		var btn = TextureButton.new()
		btn.texture_normal = res.cover
		
		var preview = preview_scene.instantiate()
		preview.level = res
		preview.hide()
		
		btn.pressed.connect(func(): _load_level(path))
		btn.mouse_entered.connect(func(): preview.show())
		btn.mouse_exited.connect(func(): preview.hide())
		
		btn.add_child(preview)
		container.add_child(btn)

func _show_preview(res: LevelResource):
	pass

func _load_level(path: String):
	GameManager.start_game(path)
