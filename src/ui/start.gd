extends Control

@export var level_select: Control
@export var card_view: Control

func _ready():
	card_view.position.x = -card_view.size.x

func _on_card_view_pressed():
	create_tween().tween_property(card_view, "position", Vector2(0, card_view.position.y), 0.5) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN_OUT)


func _on_close_card_view_pressed():
	create_tween().tween_property(card_view, "position", Vector2(-card_view.size.x, card_view.position.y), 0.5) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN_OUT)
