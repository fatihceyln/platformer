class_name Killzone extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Remove the collision shape node from the player. Body is player.
	body.get_node_or_null("%PlayerHitBox").queue_free()
	Events.player_died.emit()
