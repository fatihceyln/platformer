class_name Coin extends Area2D

@onready var game_manager: GameManager = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	game_manager.add_point()
	animation_player.play("pickup")

func _on_tree_exited() -> void:
	print("tree exited")
