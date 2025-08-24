extends GutTest

@onready var experience_tracker_script = preload("res://xplib/gameplay/ExperienceTracker.gd")
var experience_tracker: ExperienceTracker

func before_all():
	pass

func before_each():
	experience_tracker = experience_tracker_script.new()
	add_child(experience_tracker)

func after_each():
	remove_child(experience_tracker)
	experience_tracker.free()

func after_all():
	pass

#TEST-TODO: eventually expand this to test all exp tnl curves, when multiple exist

func test_character_gain_no_levels():
	watch_signals(experience_tracker)
	experience_tracker.set_exp_tnl_curve("player_character_exp_tnl")
	var exp_for_levels = experience_tracker.exp_tnl_curve_fn.call(experience_tracker.level + 1)
	experience_tracker.experience = exp_for_levels - 1
	experience_tracker.try_level_up()
	assert_signal_emitted(experience_tracker, "gained_experience")
	assert_signal_not_emitted(experience_tracker, "gained_levels")
	assert_signal_not_emitted(experience_tracker, "gained_level")


func test_character_gain_1_level():
	watch_signals(experience_tracker)
	experience_tracker.set_exp_tnl_curve("player_character_exp_tnl")
	var exp_for_levels = experience_tracker.exp_tnl_curve_fn.call(experience_tracker.level + 1)
	experience_tracker.experience = exp_for_levels
	experience_tracker.try_level_up()
	assert_signal_emitted(experience_tracker, "gained_experience")
	assert_signal_emitted_with_parameters(experience_tracker, "gained_levels", [1, 2, experience_tracker.experience])
	assert_signal_emit_count(experience_tracker, "gained_level", 1)

func test_character_gain_3_levels():
	watch_signals(experience_tracker)
	experience_tracker.set_exp_tnl_curve("player_character_exp_tnl")
	var exp_for_levels = experience_tracker.exp_tnl_curve_fn.call(experience_tracker.level + 3)
	experience_tracker.experience = exp_for_levels
	experience_tracker.try_level_up()
	assert_signal_emitted(experience_tracker, "gained_experience")
	assert_signal_emitted_with_parameters(experience_tracker, "gained_levels", [1, 4, experience_tracker.experience])
	assert_signal_emit_count(experience_tracker, "gained_level", 3)

func test_character_gain_4_levels_twice():
	watch_signals(experience_tracker)
	experience_tracker.set_exp_tnl_curve("player_character_exp_tnl")
	var exp_for_levels
	exp_for_levels = experience_tracker.exp_tnl_curve_fn.call(experience_tracker.level + 4)
	experience_tracker.experience = exp_for_levels
	experience_tracker.try_level_up()
	assert_signal_emit_count(experience_tracker, "gained_experience", 1)
	assert_signal_emitted_with_parameters(experience_tracker, "gained_levels", [1, 5, experience_tracker.experience])
	assert_signal_emit_count(experience_tracker, "gained_level", 4)

	exp_for_levels = experience_tracker.exp_tnl_curve_fn.call(experience_tracker.level + 4)
	experience_tracker.experience = exp_for_levels
	experience_tracker.try_level_up()
	assert_signal_emit_count(experience_tracker, "gained_experience", 2)
	assert_signal_emitted_with_parameters(experience_tracker, "gained_levels", [5, 9, experience_tracker.experience])
	assert_signal_emit_count(experience_tracker, "gained_level", 8)
