class_name GameManager extends Node

var score: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var game_over_reveal: AnimationPlayer = $GameOverReveal

func _ready() -> void:
	Events.player_died.connect(_on_player_died)

func add_point() -> void:
	score += 1
	score_label.text = "You collected %d coins." %score
	
func _on_player_died() -> void:
	print("on player died called")
	Engine.time_scale = 0.5
	_start_timer()
	game_over_reveal.speed_scale = 1.0 / Engine.time_scale
	game_over_reveal.play("game_over_reveal")

func _start_timer() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = 0.7
	timer.ignore_time_scale = true
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_timer_timed_out.bind(timer))
	add_child(timer)

func _timer_timed_out(timer: Timer) -> void: 
	# We do not need to call `queue_free()` on timer to remove from the hierarchy.
	# Because we are reloading the whole scene.
	# But I will leave it for demoing purposes.
	timer.queue_free() 
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
