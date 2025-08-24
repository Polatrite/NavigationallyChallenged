class_name ExperienceTracker
extends Node

const LOGGING = false
# could add lost_level functionality for downleveling?
signal gained_level(new_level, current_experience)
signal gained_levels(old_level, new_level, current_experience)
signal gained_experience(experience_gained, current_experience)

var level = 1
var _experience = 0
var experience: int:
	get:
		return _experience
	set(value):
		set_experience(value)
var exp_tnl_curve_fn: Callable

func add_experience(value) -> int:
	set_experience(_experience + value)
	return try_level_up()

func set_experience(value, emit = true):
	if emit && value > _experience:
		emit_signal("gained_experience", value - _experience, value)
	_experience = value

func get_experience():
	return _experience

func try_level_up() -> int:
	if !exp_tnl_curve_fn:
		return 0
	var old_level = level
	var levels_gained = 0
#	prints('exp', _experience, exp_tnl_curve_fn.call(level + 1))
	while _experience >= get_exp_tnl(level + 1):
		level += 1
		levels_gained += 1
		emit_signal("gained_level", level, _experience)
		if LOGGING:
			prints('gained_level', level, _experience)
	if levels_gained:
		emit_signal("gained_levels", old_level, level, _experience)
		if LOGGING:
			prints("gained_levels", old_level, level, _experience)
	return levels_gained

# exp_tnl = experience to next level
func set_exp_tnl_curve(curve_fn):
	exp_tnl_curve_fn = Callable(self, curve_fn)

func get_exp_tnl(goal_level):
	return exp_tnl_curve_fn.call(goal_level)

func player_character_exp_tnl(next_level):
	var x = next_level
	var tnl = floor(50 / 3 * (pow(x, 3) - 6 * pow(x, 2) + 17 * x - 12))
#	prints('tnl()', next_level, tnl)
	return tnl
