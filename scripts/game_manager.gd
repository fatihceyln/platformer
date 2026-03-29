class_name GameManager extends Node

var score: int = 0
@onready var score_label: Label = $ScoreLabel

func add_point() -> void:
	score += 1
	score_label.text = "You collected %d coins." %score
