@tool
extends Node

# This file requires a definition in enums.gd for the StatType enum.

var stats = {}
var stat_changes = []

func _init() -> void:
	for stat in Enum.Stat:
		stats[stat] = 0.0


func _get_property_list() -> Array:
	var props = []
	for key in Enum.Stat.keys():
		props.append({
			"name": key,
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
	return props


func g(stat: int):
	var stat_str = Enum.Stat.keys()[stat]
	return stats.get(stat_str)


func set_default_values(defaults: Dictionary):
	var value
	for stat in defaults:
		value = defaults[stat]
		stats[stat] = value


func add_stat_change(stat: int, delta_value: float, multi: bool = false):
	var stat_str = Enum.Stat.keys()[stat]
	if(multi):
		delta_value = stats[stat_str] * delta_value
	var change = {
		"stat": stat_str,
		"delta_value": delta_value,
	}
	stat_changes.push_back(change)
	var old_value = stats[stat_str]
	stats[stat_str] = old_value + delta_value
	return change


func set_stat_value(stat: int, value: float):
	var stat_str = Enum.Stat.keys()[stat]
	stats[stat_str] = value


func remove_stat_change(change: Dictionary):
	stats[change.stat] = stats[change.stat] - change.delta_value
	stat_changes.erase(change)


