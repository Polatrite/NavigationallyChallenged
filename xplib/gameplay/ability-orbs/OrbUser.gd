extends Node

signal orbs_changed(current_orbs, orbs_added, orbs_removed)

var orb_limit = 7
var equipped_abilities: Array = []
var equipped_ability_names: Array = []
var current_orbs: Array = []
var orb_types_used: Dictionary = {}

func set_equipped_abilities(ability_names: Array):
	equipped_abilities = AbilityData.map_ability_names_to_abilities(ability_names)
	equipped_ability_names = ability_names
	set_orb_types_used()

func set_orb_types_used():
	orb_types_used.clear()
	for ability in equipped_abilities:
		for key in ability.orbs_added:
			if !orb_types_used.has(key):
				orb_types_used[key] = true
		for key in ability.orbs_removed:
			if !orb_types_used.has(key):
				orb_types_used[key] = true

func handle_ability_orbs(orbs_added: Dictionary, orbs_removed: Dictionary):
#	prints('handle_ability_orbs', orbs_added, orbs_removed)
	if !check_has_orbs(orbs_removed):
		print('[ERROR] handle_ability_orbs() creature did not have orbs')
	_remove_orbs(orbs_removed)
	_add_orbs(orbs_added)
	emit_signal("orbs_changed", current_orbs, orbs_added, orbs_removed)

func num_orbs() -> int:
	return current_orbs.size()

func num_orbs_of_type(orb_type: int) -> int:
	var count = 0
	for orb in current_orbs:
		if orb == orb_type:
			count += 1
	return count

func clear_orbs():
	current_orbs.clear()
	emit_signal("orbs_changed", current_orbs, {}, {})

func consume_orbs_of_type(orb_type: int, num_to_consume: int = 9999) -> int:
	var count = 0
	for i in range(current_orbs.size()-1, -1, -1):
		var orb = current_orbs[i]
		if orb == orb_type && num_to_consume > 0:
			num_to_consume -= 1
			count += 1
			current_orbs.remove(i)
	return count

func _add_orbs(orbs: Dictionary) -> int:
#	print('add_orbs ', current_orbs, ' ', orbs)
	var orbs_added = 0
	for orb in orbs:
		var count = orbs[orb]
		while count:
			count -= 1
			if current_orbs.size() >= orb_limit:
				break
			orbs_added += 1
			current_orbs.push_back(orb)
#			print('  added ', orb)
	return orbs_added

func check_has_orbs(orbs: Dictionary) -> bool:
#	print('check_has_orbs ', current_orbs, ' ', orbs)
	for orb in orbs:
		var count = orbs[orb]
#		print('  needs ', count, ' of type ', orb)
		for creature_orb in current_orbs:
#			print('    scanned ', creature_orb)
			if creature_orb == orb:
#				print('    found ', orb, ' count ', count)
				count -= 1
		if count > 0:
#			print('  does not have')
			return false
#	print('  has!')
	return true

func _remove_orbs(orbs: Dictionary) -> int:
#	print('remove_orbs ', current_orbs, ' ', orbs)
	var orbs_removed = 0
	for orb in orbs:
		var count = orbs[orb]
		while count:
			current_orbs.remove(current_orbs.find(orb))
#			print('  removed ', orb)
			count -= 1
			orbs_removed += 1
	return orbs_removed

func should_use_ability(ability, attacker, target):
	if 'should_use_fn' in ability && ability.should_use_fn:
		var tes()tfunc = ability.should_use_fn
		assert(testfunc.is_valid())
		return ability.should_use_fn.call_func(attacker, target)
	else:
		return true

func get_next_ability(gid, cooldown_manager, attacker, target):
	for ability in equipped_abilities:
		if check_has_orbs(ability.orbs_removed):
			if !cooldown_manager.has_cooldown(gid, ability.uid) && should_use_ability(ability, attacker, target):
				return ability

