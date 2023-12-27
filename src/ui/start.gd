extends Control

@export var level_select: Control
@export var card_view: Control
@export var card_select: Control

var tw := TweenCreator.new(self)

func _ready():
	card_view.position.x = -card_view.size.x
	card_view.show()

func _on_card_view_pressed():
	create_tween().tween_property(card_view, "position", Vector2(0, card_view.position.y), 0.5) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN_OUT)


func _on_close_card_view_pressed():
	create_tween().tween_property(card_view, "position", Vector2(-card_view.size.x, card_view.position.y), 0.5) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN_OUT)


func _on_level_select_select_cards(lvl):
	card_select.open_select(lvl)


func _on_card_select_cards_selected(cards):
	GameManager.start_game(card_select.level, cards)
