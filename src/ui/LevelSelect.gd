extends Control

const LEVELS_DIR = "res://src/levels"

@export var preview_scene: PackedScene
@export var container: Control

var inactive_color = Color(0.7, 0.7, 0.7)

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
		
		btn.modulate = inactive_color
		btn.pressed.connect(func(): _load_level(path))
		btn.mouse_entered.connect(func(): _on_enter(btn))
		btn.mouse_exited.connect(func(): _on_exit(btn))
		
		btn.add_child(preview)
		container.add_child(btn)

func _on_enter(btn):
	#preview.show()
	btn.modulate = Color.WHITE
	
func _on_exit(btn):
	#preview.hide()
	btn.modulate = inactive_color

func _load_level(path: String):
	GameManager.start_game(path)
