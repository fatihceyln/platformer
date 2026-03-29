extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# Klavye bırakıldığında yatay hızı sıfıra düşürür. Her seferde SPEED değeri kadar düşürür.
		# move_toward(100, 0, 30) → 70 (30 azalır)
		# move_toward(20, 0, 30) → 0 (20’yi aşıp negatife gitmez)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
