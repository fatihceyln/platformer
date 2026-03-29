class_name Player extends CharacterBody2D

@export var SPEED: float = 130.0
@export var JUMP_VELOCITY: float = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	handle_gravity(delta)
	handle_jump()
	flip_sprite(direction)
	play_animations(direction)
	move(direction)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func flip_sprite(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func play_animations(direction: float) -> void:
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func move(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		# When input stops, ease horizontal velocity toward zero by up to SPEED per physics step.
		# move_toward(100, 0, 30) → 70 (drops by 30)
		# move_toward(20, 0, 30) → 0 (does not overshoot past zero)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
