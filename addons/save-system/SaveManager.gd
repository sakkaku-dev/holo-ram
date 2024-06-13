class_name SaveManager
extends Node

const SAVES_FOLDER = "user://saves"
const SAVE_FILE = SAVES_FOLDER + "/save_%s.dat"

func _ready():
	if not DirAccess.dir_exists_absolute(SAVES_FOLDER):
		DirAccess.make_dir_absolute(SAVES_FOLDER)


func save_to_slot(slot: int, data):
	var file_name = SAVE_FILE % slot
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	if file == null:
		Tracer.error("Failed to save data to %s: %s" % [file_name, file.get_open_error()])
	else:
		file.store_var(data)
		Tracer.debug("Save %s" % str(data))
	file.close()


func load_from_slot(slot: int):
	var file_name = SAVE_FILE % slot
	var file = FileAccess.open(file_name, FileAccess.READ)
	var data
	if file == null:
		Tracer.error("Failed to load data from %s: %s" % [file_name, FileAccess.get_open_error()])
	else:
		data = file.get_var()
		if data:
			Tracer.debug("Load %s" % str(data))
		file.close()

	return data


func is_slot_saved(slot: int):
	var file_name = SAVE_FILE % slot
	return FileAccess.file_exists(file_name)
