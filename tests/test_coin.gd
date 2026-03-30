extends GutTest

const GUT_COIN_LEVEL: PackedScene = preload("res://tests/fixtures/gut_coin_pickup_level.tscn")


func make_coin_level() -> Node2D:
	return GUT_COIN_LEVEL.instantiate() as Node2D


func test_body_entered_adds_point_and_plays_pickup() -> void:
	var level: Node2D = make_coin_level()
	add_child_autofree(level)
	await wait_process_frames(1)
	var gm: GameManager = level.get_node("GameManager") as GameManager
	var coin: Coin = level.get_node("TestCoin") as Coin

	var body: Node2D = autofree(Node2D.new())
	coin._on_body_entered(body)
	assert_eq(gm.score, 1)
	assert_eq(gm.score_label.text, "You collected 1 coins.")
	assert_eq(String(coin.animation_player.current_animation), "pickup")
	assert_true(coin.animation_player.is_playing())
