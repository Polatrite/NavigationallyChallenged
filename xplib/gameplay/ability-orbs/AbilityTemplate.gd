class_name AbilityTemplate
extends Node

var uid = -1
var pretty_name = ''
var base_damage = 0
var damage_multi = 0
var cooldown = 0 # not implemented
var is_physical = false
var is_magic = false
var orbs_added = {}
var orbs_removed = {}
var tags = {}
var orbs_added_count = 0
var orbs_removed_count = 0
var orb_count_delta = 0
var primary_orb_type
# (attacker, victim)
var should_use_fn
# (attacker, victim, attack_result, orb_added_count?)
var pre_use_fn
# (attacker, victim, attack_result, orb_added_count?)
var post_use_fn
# (attacker, victim, damage_base, damage_multi, damage_more: Array)
var get_damage_bonuses_fn
var description: String
var text_description: String
var orb_description: String
var orb_short_description: String

func initialize(_name: String, params: Dictionary):
	pretty_name = _name
	text_description = PList.tryget(params, 'text_description', '')
	damage_multi = PList.tryget(params, 'power', 0)
	cooldown = PList.tryget(params, 'cooldown', 0)
	
	for tag in params.tags:
		tags[tag] = true
	
	var orb_changes = PList.tryget(params, 'orb_changes', [])
	for change in orb_changes:
		var type = change[0]
		var value = change[1]
		if value > 0:
			orbs_added[type] = value
		elif value < 0:
			orbs_removed[type] = value
		else:
			print('\t\t[ERROR] Tried to add an orb change with a value of 0')

	var highest_count = 0
	var highest_type
	for orb in orbs_added:
		var count = orbs_added[orb]
		if count > highest_count:
			highest_count = count
			highest_type = orb
		orbs_added_count += count
		tags[Enum.get_damage_type_name(orb, true)] = true
	
	for orb in orbs_removed:
		var count = abs(orbs_removed[orb])
		if count > highest_count:
			highest_count = count
			highest_type = orb
		orbs_removed[orb] = count
		orbs_removed_count += count
		tags[Enum.get_damage_type_name(orb, true)] = true
	
	orb_count_delta = orbs_added_count - orbs_removed_count
	primary_orb_type = highest_type

	if params.has('should_use_fn'):
		var should_use = params['should_use_fn']
		if typeof(should_use) == TYPE_BOOL:
			printerr(str('\t\t', pretty_name, ' needs its should_use_fn'))
		else:
			should_use_fn = should_use
	if params.has('pre_use_fn'):
		var pre_use = params['pre_use_fn']
		if typeof(pre_use) == TYPE_BOOL:
			printerr(str('\t\t', pretty_name, ' needs its pre_use_fn'))
		else:
			pre_use_fn = pre_use
	if params.has('post_use_fn'):
		var post_use = params['post_use_fn']
		if typeof(params['post_use_fn']) == TYPE_BOOL:
			printerr(str('\t\t', pretty_name, ' needs its post_use_fn'))
		else:
			post_use_fn = post_use
	if params.has('get_damage_bonuses_fn'):
		var get_damage_bonuses = params['get_damage_bonuses_fn']
		if typeof(params['get_damage_bonuses_fn']) == TYPE_BOOL:
			printerr(str('\t\t', pretty_name, ' needs its get_damage_bonuses_fn'))
		else:
			get_damage_bonuses_fn = get_damage_bonuses

	if orbs_added_count >= orbs_removed_count:
		tags['create'] = true
	elif orbs_removed_count > orbs_added_count:
		tags['expend'] = true

	apply_derived_tags()
	set_reference_bools()

	build_description()
	build_orb_description()
	build_orb_short_description()
	print('\tAdded ability: ', pretty_name)


func apply_derived_tags():
	pass

# this sets some booleans for checks that happen a lot
func set_reference_bools():
	if tags.get('physical'):
		is_physical = true
		is_magic = false
	if tags.get('magic'):
		is_magic = true
		is_physical = false


func build_description():
	var arr: PackedStringArray = []
	if damage_multi:
		arr.push_back(str("[b]Damage: ", damage_multi, "%[/b]  "))
	if cooldown:
		arr.push_back(str("[b][url=Help|Keyword|Cooldown]CD[/url]: ", cooldown/1000, "s[/b]"))
	arr.push_back('\n')
	var first = true
	arr.push_back('[')
	for tag in tags:
		var formatted_tag = str('[url=Help|Keyword|', str(tag).capitalize(), ']', str(tag).capitalize(), '[/url]')
		if first:
			arr.push_back(formatted_tag)
			first = false
		else:
			arr.push_back(str(", ", formatted_tag))
	arr.push_back(']\n\n')
	if !text_description.is_empty():
		arr.push_back(replace_substitutions(str(text_description, "\n")))
	description = "".join(arr)
	# print(description)


func replace_substitutions(text: String) -> String:
	var ex = RegEx.new()
	ex.compile("{{([a-zA-Z0-9 -'\"]+)}}") # find all description-like characters {{between curly braces}}
	return ex.sub(text, "[url=Help|Keyword|$1]$1[/url]", true)


func build_orb_description():
	var arr: PackedStringArray = []
	for orb in orbs_added:
		var count = orbs_added[orb]
		var orb_name = Enum.get_damage_type_name(orb, true)
		var orb_name_c = Enum.get_damage_type_name(orb, false)
		arr.push_back(str("+", str("$", orb_name).repeat(count), " ", count, " ", orb_name_c))
	for orb in orbs_removed:
		var count = orbs_removed[orb]
		var orb_name = Enum.get_damage_type_name(orb, true)
		var orb_name_c = Enum.get_damage_type_name(orb, false)
		arr.push_back(str("-", str("$", orb_name).repeat(count), " ", count, " ", orb_name_c))
	orb_description = "\n".join(arr)

func build_orb_short_description():
	var arr: PackedStringArray = []
	for orb in orbs_added:
		var count = orbs_added[orb]
		var orb_name = Enum.get_damage_type_short_name(orb).capitalize()
		arr.push_back(str("+", count, orb_name))
	for orb in orbs_removed:
		var count = orbs_removed[orb]
		var orb_name = Enum.get_damage_type_short_name(orb).capitalize()
		arr.push_back(str("-", count, orb_name))
	orb_short_description = ",".join(arr)

