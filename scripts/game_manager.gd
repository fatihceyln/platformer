class_name GameManager extends Node

var score: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var game_over_dim: ColorRect = $Overlay/Dim
@onready var game_over_label: Label = $Overlay/GameOverLabel


func show_game_over_overlay() -> void:
	game_over_dim.visible = true
	game_over_label.visible = true


func add_point() -> void:
	score += 1
	score_label.text = "You collected %d coins." %score
