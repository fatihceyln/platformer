extends RigidBody2D

func _on_hit_area_area_entered(area: Area2D) -> void:
	queue_free()
	var slime: Slime = area.get_parent() as Slime
	if slime != null:
		slime.take_hit()
