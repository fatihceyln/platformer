extends GutTest


func make_sut() -> GameManager:
	var gm: GameManager = GameManager.new()
	var lbl: Label = Label.new()
	lbl.name = "ScoreLabel"
	gm.add_child(lbl)
	add_child_autofree(gm)
	return gm


func test_initial_score_is_zero() -> void:
	var gm: GameManager = make_sut()
	assert_eq(gm.score, 0)
	assert_eq(gm.score_label.text, "")


func test_add_point_increments_score_and_updates_label() -> void:
	var gm: GameManager = make_sut()
	gm.add_point()
	assert_eq(gm.score, 1)
	assert_eq(gm.score_label.text, "You collected 1 coins.")
	gm.add_point()
	assert_eq(gm.score, 2)
	assert_eq(gm.score_label.text, "You collected 2 coins.")
