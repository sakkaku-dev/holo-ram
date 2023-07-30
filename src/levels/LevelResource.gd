class_name LevelResource
extends Resource

enum Type {
	HOLOMYTH,
	HOLOGAMERS,
}

@export var cards: Array[CardResource]
@export var name: String
@export var type: Type
@export var cover: Texture2D
