extends Node


enum Stat {
	noop,
	health,
	damage,
}

enum Buff {
	unit_test_buff_no_stack,
	unit_test_buff_refresh_stack,
	unit_test_buff_increase_stack,
	unit_test_buff_rolling_stack,
	
}

enum BuffDuration {
	none,
	refresh,
	increase,
	rolling,
}

# also includes Abilities in the 1000-9999 enum space
enum CooldownType {
	movement = 1,
	attack = 2,
}


enum Direction {
	north = 1,
	south = 2,
	east = 4,
	west = 8,
}

enum DamageStat {
	Physical = 1,
	Magic = 2,
}

enum DamageType {
	FIRST = 1,
	Form = 1,
	Fire = 2,
	Cold = 3,
	Nature = 4,
	Light3D = 5,
	Darkness = 6,
	Supernatural = 7,
	LAST = 7,
}

enum ItemSlotCategory {
	FIRST = 1,
	Inventory = 1,
	Equipment = 2,
	Furnace = 3,
	GemSocket = 4,
	AbilitySocket = 5,
	Consumable = 6,
	Activateable = 7,
	EquipWeapon = 100,
	EquipAccessory = 101,
	EquipSomething = 102,
	Creature = 1000,
	CreatureUnevolved = 1001,
	CreatureEvolved = 1002,
	CreatureUnfused = 1003,
	CreatureFused = 1004,
	LAST = 1000,
}

func get_damage_type_name(dam, to_lower = false) -> String:
	var ret: String
	match dam:
		DamageType.Form:
			ret = "Form"
		DamageType.Fire:
			ret = "Fire"
		DamageType.Cold:
			ret = "Cold"
		DamageType.Nature:
			ret = "Nature"
		DamageType.Light3D:
			ret = "Light3D"
		DamageType.Darkness:
			ret = "Darkness"
		DamageType.Supernatural:
			ret = "Supernatural"
	if to_lower:
		return ret.to_lower()
	return ret

func get_damage_type_short_name(dam):
	match dam:
		DamageType.Form:
			return "F"
		DamageType.Fire:
			return "R"
		DamageType.Cold:
			return "C"
		DamageType.Nature:
			return "N"
		DamageType.Light3D:
			return "L"
		DamageType.Darkness:
			return "D"
		DamageType.Supernatural:
			return "S"

func get_damage_type_emoji(dam):
	match dam:
		DamageType.Form:
			return "??"
		DamageType.Fire:
			return "??"
		DamageType.Cold:
			return "??"
		DamageType.Nature:
			return "??"
		DamageType.Light3D:
			return "?"
		DamageType.Darkness:
			return "?"
		DamageType.Supernatural:
			return "??"

func get_damage_stat_name(stat, to_lower = false) -> String:
	var ret: String
	match stat:
		DamageStat.Physical:
			ret = "Physical"
		DamageStat.Magic:
			ret = "Magic"
	if to_lower:
		return ret.to_lower()
	return ret

