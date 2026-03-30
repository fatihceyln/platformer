class_name GameManager extends Node

var score: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var game_over_reveal: AnimationPlayer = $GameOverReveal

func show_game_over_overlay() -> void:
	game_over_reveal.speed_scale = 1.0 / Engine.time_scale
	game_over_reveal.play("game_over_reveal")

func add_point() -> void:
	score += 1
	score_label.text = "You collected %d coins." %score
