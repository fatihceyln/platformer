class_name Killzone extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	body.get_node("CollisionShape2D").queue_free() # remove collision shape node from the player. body is player.
	Engine.time_scale = 0.5
	var game_manager: GameManager = get_parent().get_node("%GameManager") as GameManager
	if game_manager:
		game_manager.show_game_over_overlay()
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
