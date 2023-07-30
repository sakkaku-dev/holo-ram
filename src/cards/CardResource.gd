class_name CardResource
extends Resource

enum Type {
	AME,
	CALLI,
	GURA,
	INA,
	KIARA,
	KORONE,
	OKAYU,
	FUBUKI,
	MIO,
}

@export var profile: Texture2D
@export var border_color: Color
@export var character: PackedScene
@export var type: Type

@export var illust: Texture2D
@export var name: String
@export var text: String
