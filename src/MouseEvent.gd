class_name MouseEvent
extends TextureButton

@export var hover_color = Color.RED
@export var color_rect: ColorRect

var hover := false

func _ready():
	position = Vector2.ZERO - size/2.
	mouse_entered.connect(func(): hover = true)
	mouse_exited.connect(func(): hover = false)

func _process(delta):
	z_index = 10 if hover else 0
	color_rect.color = hover_color if hover else Color.TRANSPARENT
