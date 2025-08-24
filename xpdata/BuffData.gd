extends Node

var data: Dictionary = { }

var unit_test_buff_template = {
	"duration_ms": 3000,
	"infinite_duration": false,
	"removed_on_death": true,
	"show_on_ui": true,
	"default_stacks": 1,
	"reapply_stacks": 1,
	"reapply_duration_ms": 3000,
	"max_possible_duration_ms": 15000,
	"tick_interval_ms": 1000,
#	"can_apply_to_gid_fn": null,
	"apply_fn": Callable(self, "_unit_test_buff_apply_fn"),
	"update_stacks_fn": Callable(self, "_unit_test_buff_update_stacks_fn"),
	"tick_fn": Callable(self, "_unit_test_buff_tick_fn"),
	"wear_off_fn": Callable(self, "_unit_test_buff_wear_off_fn"),
}

func _init() -> void:
	var plog = PLog.print_init('Loading buff definitions')
	setup_unit_test_buffs()
	plog.print_end('success!', true)
func setup_buff(buff_type: int, params):
	params.buff_type = buff_type
	data[buff_type] = BuffDefinition.new(params)
	prints('\tAdded buff:', params.pretty_name)

func setup_unit_test_buffs():
	var unit_test_buff_def
	unit_test_buff_def = unit_test_buff_template.duplicate()
	unit_test_buff_def['buff_type'] = Enum.Buff.unit_test_buff_no_stack
	unit_test_buff_def['pretty_name'] = "UnitTestBuffNone"
	unit_test_buff_def['duration_type'] = Enum.BuffDuration.none
	data[Enum.Buff.unit_test_buff_no_stack] = BuffDefinition.new(unit_test_buff_def)
	
	unit_test_buff_def = unit_test_buff_template.duplicate()
	unit_test_buff_def['buff_type'] = Enum.Buff.unit_test_buff_refresh_stack
	unit_test_buff_def['pretty_name'] = "UnitTestBuffRefresh"
	unit_test_buff_def['duration_type'] = Enum.BuffDuration.refresh
	data[Enum.Buff.unit_test_buff_refresh_stack] = BuffDefinition.new(unit_test_buff_def)
	
	unit_test_buff_def = unit_test_buff_template.duplicate()
	unit_test_buff_def['buff_type'] = Enum.Buff.unit_test_buff_increase_stack
	unit_test_buff_def['pretty_name'] = "UnitTestBuffIncrease"
	unit_test_buff_def['duration_type'] = Enum.BuffDuration.increase
	data[Enum.Buff.unit_test_buff_increase_stack] = BuffDefinition.new(unit_test_buff_def)

	unit_test_buff_def = unit_test_buff_template.duplicate()
	unit_test_buff_def['buff_type'] = Enum.Buff.unit_test_buff_rolling_stack
	unit_test_buff_def['pretty_name'] = "UnitTestBuffRolling"
	unit_test_buff_def['duration_type'] = Enum.BuffDuration.rolling
	data[Enum.Buff.unit_test_buff_rolling_stack] = BuffDefinition.new(unit_test_buff_def)


# Unit Test Functions
func _unit_test_buff_apply_fn(buff: Buff, def: BuffDefinition):
	pass
func _unit_test_buff_update_stacks_fn(buff: Buff, def: BuffDefinition, old_stacks: int, new_stacks: int):
	pass
func _unit_test_buff_tick_fn(buff: Buff, def: BuffDefinition):
	pass
func _unit_test_buff_wear_off_fn(buff: Buff, def: BuffDefinition):
	pass

# Missing Warning Functions
func _missing_apply_fn(buff: Buff, def: BuffDefinition):
	printerr(str(def.pretty_name, ' missing apply_fn()'))
func _missing_update_stacks_fn(buff: Buff, def: BuffDefinition, old_stacks: int, new_stacks: int):
	printerr(str(def.pretty_name, ' missing update_stacks_fn()'))
func _missing_tick_fn(buff: Buff, def: BuffDefinition):
	printerr(str(def.pretty_name, ' missing tick_fn()'))
func _missing_wear_off_fn(buff: Buff, def: BuffDefinition):
	printerr(str(def.pretty_name, ' missing wear_off_fn()'))

