extends Node

const NAMES = "res://src/converter/holo_names.txt"
const OUTPUT = GameManager.CHAR_FOLDER

func _ready():
	var file = FileAccess.open(NAMES, FileAccess.READ)
	if file == null:
		print("File %s not found" % NAMES)
		return
	
	for filename in DirAccess.get_files_at(OUTPUT):  
		DirAccess.remove_absolute(OUTPUT + filename)
	
	var idx = 0
	var g_idx = 0
	var name_idx = {}
	var group_idx = {}
	var names = {}
	var group = ""
	while not file.eof_reached():
		var line = file.get_line()
		if line == "": continue
		if line.begins_with("--"):
			group = line.substr(2).strip_edges()
			idx = 0
			g_idx += 1
			continue
		
		var parts = line.strip_edges().split(";")
		var char = CardResource.new()
		char.id = parts[0]
		char.name = parts[1]
		char.group = group
		names[char.id] = char

		group_idx[group] = g_idx
		if char.id in name_idx:
			print("%s already exists in names" % char.id)
		else:
			name_idx[char.id] = idx
		
		idx += 1
		
	file.close()
	
	for res in names.values():
		var name_id = name_idx[res.id] if res.id in name_idx else 999
		var group_id = group_idx[res.group] if res.group in group_idx else 999
		var char_file = OUTPUT + ("%x%x_%s.tres" % [group_id, name_id, (res.group + "_" + res.id)])
		var err = ResourceSaver.save(res, char_file)
		if err != OK:
			print("Failed to save member %s: %s, %s" % [res.id, err, char_file])
