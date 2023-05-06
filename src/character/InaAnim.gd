@tool
extends SpriteAnimTool

@export var sprite: NodePath

func update():
	add_animation(SpriteAnimTool.Builder.new(sprite).setName("run").setRange(0, 3).setDuration(0.8))
