class_name GameManager extends Node

const CONFETTI_BURST: PackedScene = preload("res://scenes/confetti_burst.tscn")
const GAME_OVER_HUD: PackedScene = preload("res://scenes/game_over_hud.tscn")

var score: int = 0
var _total_coins: int = 0
@onready var score_label: Label = $ScoreLabel

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
	
	var game_over_hud: GameOverHUD = GAME_OVER_HUD.instantiate()
	add_child(game_over_hud)
	game_over_hud.finished.connect(_on_game_over_hud_finished)
	game_over_hud.start_animation()

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

func _on_game_over_hud_finished() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
