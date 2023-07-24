extends Control

const LEVELS_DIR = "res://src/levels"

@export var game_scene: PackedScene
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
		#btn.disabled = level in GameManager.unlocked_levels
		btn.pressed.connect(func(): _load_level(path))
		container.add_child(btn)
		print("Add level %s" % level)

func _load_level(path: String):
	GameManager.current_level_file = path
	get_tree().change_scene_to_packed(game_scene)
