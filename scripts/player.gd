class_name Player extends CharacterBody2D

const FRUIT: PackedScene = preload("uid://cnn4am0k2mqp8")

@export var speed: float = 130.0
@export var jump_velocity: float = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _can_throw_fruit: bool = true

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	_handle_gravity(delta)
	_handle_jump()
	_flip_sprite(direction)
	_play_animations(direction)
	_move(direction)
	await _throw_fruit_if_needed()

func _throw_fruit_if_needed() -> void:
	if Input.is_action_pressed("throw_fruit") && _can_throw_fruit:
		_can_throw_fruit = false
		var fruit: Node2D = FRUIT.instantiate()
		var root: Node = get_tree().root
		root.add_child(fruit)
		fruit.position = global_position
		fruit.position.y -= 10
		await get_tree().create_timer(1).timeout
		_can_throw_fruit = true

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func _flip_sprite(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func _play_animations(direction: float) -> void:
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func _move(direction: float) -> void:
	if direction:
		velocity.x = direction * speed
	else:
		# When input stops, ease horizontal velocity toward zero by up to speed per physics step.
		# move_toward(100, 0, 30) → 70 (drops by 30)
		# move_toward(20, 0, 30) → 0 (does not overshoot past zero)
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
