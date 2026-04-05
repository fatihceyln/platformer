class_name GameOverHUD extends CanvasLayer

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finished.emit()

func start_animation() -> void:
	animation_player.speed_scale = 1.0 / Engine.time_scale
	animation_player.play("reveal")
	
