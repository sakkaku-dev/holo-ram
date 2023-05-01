@tool
extends SpriteAnimTool

@export var card_sprite: NodePath
@export var platform_sprite: NodePath

func update():
	add_animation(SpriteAnimTool.Builder.new().setNode(card_sprite).setName("show").setFrames([0, 1, 2, 3, 0]))
	add_animation(SpriteAnimTool.Builder.new().setNode(platform_sprite).setName("show").setFrames([0, 1, 2, 3, 0]))
	
	add_animation(SpriteAnimTool.Builder.new().setNode(card_sprite).setName("hide").setFrames([0, 1, 2, 3, 0]))
	add_animation(SpriteAnimTool.Builder.new().setNode(platform_sprite).setName("hide").setFrames([0, 1, 2, 3, 0]))
