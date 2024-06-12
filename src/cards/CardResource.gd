class_name CardResource
extends Resource

const SCENE_FOLDER = "res://src/cards/scenes/"
const PROFILE_FOLDER = "res://src/cards/profile/"

@export var id := ""
@export var name := ""
@export var group := ""
@export var hair_color := ""

func get_profile() -> Texture2D:
	var path = PROFILE_FOLDER + "%s.png" % id
	if ResourceLoader.exists(path):
		return load(path)
	return null

func get_scene() -> PackedScene:
	var path = SCENE_FOLDER + "%s.tscn" % id
	if ResourceLoader.exists(path):
		return load(path)
	return null
