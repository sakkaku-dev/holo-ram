class_name CacheProperties
extends Node

@export var properties: Array[String]
@export var node_path: NodePath
@onready var node := get_node(node_path) if node_path else get_parent()

var logger = Tracer 


func _ready():
	add_to_group(CacheManager.PERSIST_GROUP)


func save_data():
	var data = {}
	for prop in properties:
		data[prop] = node.get(prop)

	Tracer.debug("Save for %s: %s" % [get_tree().current_scene.get_path_to(node), str(data)])
	return data


func load_data(data: Dictionary):
	Tracer.debug("Load for %s: %s" % [get_tree().current_scene.get_path_to(node), str(data)])
	for prop in data:
		node.set(prop, data[prop])
