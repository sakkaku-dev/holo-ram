extends Control

@export var clone_label: Label
@export var point_label: Label

func _ready():
	GameManager.points_changed.connect(func(): point_label.text = "Points: %s" % GameManager.points)
	GameManager.clones_changed.connect(func(): clone_label.text = "Clones: %s" % GameManager.clones)
