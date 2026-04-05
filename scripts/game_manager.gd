class_name GameManager extends Node

const CONFETTI_BURST: PackedScene = preload("res://scenes/confetti_burst.tscn")

var score: int = 0
var _total_coins: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var game_over_reveal: AnimationPlayer = $GameOverReveal

func _ready() -> void:
	Events.player_died.connect(_on_player_died)
	_calculate_total_coins()

func _calculate_total_coins() -> void:
	var world: Node = get_parent()
	if world == null: return
	var coins: Node = world.get_node_or_null("Coins")
	if coins == null: return
	_total_coins = coins.get_child_count()

func add_point() -> void:
	score += 1
	score_label.text = "You collected %d coins." % score
	if _total_coins > 0 and score >= _total_coins:
		_spawn_confetti_at_player()

func _on_player_died() -> void:
	score = 0
	Engine.time_scale = 0.5
	_start_game_over_timer()
	game_over_reveal.speed_scale = 1.0 / Engine.time_scale
	game_over_reveal.play("game_over_reveal")
		

func _start_game_over_timer() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = 0.7
	timer.ignore_time_scale = true
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_game_over_timer_timed_out.bind(timer))
	add_child(timer)

func _game_over_timer_timed_out(timer: Timer) -> void: 
	# We do not need to call `queue_free()` on timer to remove from the hierarchy.
	# Because we are reloading the whole scene.
	# But I will leave it for demoing purposes.
	timer.queue_free() 
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


func _spawn_confetti_at_player() -> void:
	var world: Node = get_parent()
	if world == null: return
	var player: Node2D = world.get_node_or_null("Player") as Node2D
	if player == null: return
	var burst: GPUParticles2D = CONFETTI_BURST.instantiate() as GPUParticles2D
	world.add_child(burst)
	burst.global_position = player.global_position
	burst.finished.connect(burst.queue_free)
	burst.emitting = true
	burst.restart()
