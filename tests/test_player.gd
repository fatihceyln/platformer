extends GutTest


func make_one_pixel_texture() -> ImageTexture:
	var img: Image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	return ImageTexture.create_from_image(img)


func make_minimal_sprite_frames() -> SpriteFrames:
	var sf: SpriteFrames = SpriteFrames.new()
	var tex: Texture2D = make_one_pixel_texture()
	for anim_name: StringName in [&"idle", &"run", &"jump"]:
		sf.add_animation(anim_name)
		sf.add_frame(anim_name, tex)
	return sf


func make_sut(disable_physics: bool = true) -> Player:
	var player: Player = Player.new()
	var sprite: AnimatedSprite2D = AnimatedSprite2D.new()
	sprite.name = "AnimatedSprite2D"
	sprite.sprite_frames = make_minimal_sprite_frames()
	player.add_child(sprite)
	if disable_physics:
		player.set_physics_process(false)
	return player


func test_flip_sprite_right_and_left() -> void:
	var player: Player = make_sut()
	add_child_autofree(player)
	await wait_process_frames(1)
	var sprite: AnimatedSprite2D = player.animated_sprite
	player.flip_sprite(1.0)
	assert_false(sprite.flip_h)
	player.flip_sprite(-1.0)
	assert_true(sprite.flip_h)


func test_flip_sprite_zero_preserves_flip() -> void:
	var player: Player = make_sut()
	add_child_autofree(player)
	await wait_process_frames(1)
	var sprite: AnimatedSprite2D = player.animated_sprite
	player.flip_sprite(-1.0)
	assert_true(sprite.flip_h)
	player.flip_sprite(0.0)
	assert_true(sprite.flip_h)
	player.flip_sprite(1.0)
	assert_false(sprite.flip_h)
	player.flip_sprite(0.0)
	assert_false(sprite.flip_h)


func test_handle_jump_applies_velocity_when_on_floor_and_jump_pressed() -> void:
	var floor_body: StaticBody2D = StaticBody2D.new()
	floor_body.position = Vector2(256.0, 200.0)
	var floor_shape: CollisionShape2D = CollisionShape2D.new()
	var floor_rect: RectangleShape2D = RectangleShape2D.new()
	floor_rect.size = Vector2(512.0, 32.0)
	floor_shape.shape = floor_rect
	floor_body.add_child(floor_shape)

	var player: Player = make_sut(false)
	var p_shape: CollisionShape2D = CollisionShape2D.new()
	var p_rect: RectangleShape2D = RectangleShape2D.new()
	p_rect.size = Vector2(16.0, 32.0)
	p_shape.shape = p_rect
	player.add_child(p_shape)
	player.position = Vector2(256.0, 168.0)

	add_child_autofree(floor_body)
	add_child_autofree(player)
	await wait_physics_frames(20)
	assert_true(player.is_on_floor(), "player should rest on floor")
	var sender: GutInputSender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)
	sender.action_down(&"jump")
	await wait_physics_frames(1)
	assert_eq(player.velocity.y, player.JUMP_VELOCITY)
	sender.release_all()
