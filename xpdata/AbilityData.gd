extends Node
var template = preload("res://gameplaylib/ability-orbs/AbilityTemplate.gd")
var ability_map = {}
var abilities = []
var ability_uid = 1000
func consume_buff_stacks(buff_types: Array, entity, stack_count: int) -> int:
	var stacks_consumed = 0
	for buff_type in buff_types:
		var buff = BuffManager.get_buff(buff_type, entity)
		if buff && buff.stacks >= stack_count:
			BuffManager.wear_off_stacks(buff, stack_count)
			stacks_consumed += stack_count
	return stacks_consumed
func sum_buff_stacks(buff_types: Array, entity) -> int:
	var sum = 0
	for buff_type in buff_types:
		var buff = BuffManager.get_buff(buff_type, entity)
		if buff:
			sum += buff.stacks
	return sum
func _init() -> void:
	var plog = PLog.print_init('Loading ability data')
	var ability: AbilityTemplate
	ability = add_ability_params("Annihilation", {
		"name": "Annihilation",
		"power": 575,
		"text_description": "Grants 50% increased magical damage and Thwompy (10% increased base damage, lasts 15s).",
		"tags": [
			"sorcery",
			"magical"
		],
		"orb_changes": [
			[Enum.DamageType.Nature, -5]
		],
	})
	
func add_ability_params(_name: String, params: Dictionary):
	var ability: AbilityTemplate
	ability = template.new()
	ability.initialize(_name, params)
	ability.uid = ability_uid
	ability_uid += 1
	ability_map[_name] = ability
	abilities.push_back(ability)
#	print(str('Added ability: ', ability))
	return ability
func map_ability_names_to_abilities(abilityNames: Array):
	var _abilities = []
	for abilityName in abilityNames:
		if !AbilityData.ability_map.has(abilityName):
			continue
		var ability = AbilityData.ability_map[abilityName]
		assert(ability, str('Could not find ability definition for ', abilityName))
		_abilities.push_back(ability)
	return _abilities
