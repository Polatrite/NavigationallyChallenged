extends GutTest

@onready var base_entity_script = preload("res://xplib/gameplay/BaseEntity.gd")
var BuffManager := preload("res://xplib/gameplay/buff/BuffManager.gd").new()

var entity: BaseEntity

func before_all():
	pass

func before_each():
	entity = base_entity_script.new()
	entity.gid = 12345

func after_each():
	entity.free()
	BuffManager._clear_all_buffs()
	simulate(BuffManager, 60, 0.016666)

func after_all():
	pass

func test_apply_buff():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	assert_not_null(BuffManager.get_buff(Enum.Buff.unit_test_buff_refresh_stack, entity))
	simulate(BuffManager, 300, 0.016666)
	assert_null(BuffManager.get_buff(Enum.Buff.unit_test_buff_refresh_stack, entity))

func test_buff_emits_events():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	watch_signals(buff)
	simulate(BuffManager, 1.2, 0.016666)
	BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	simulate(BuffManager, 300, 0.016666)
	assert_signal_emit_count(buff, "ticked", 3)
	assert_signal_emit_count(buff, "reapplied", 1)
	assert_signal_emitted_with_parameters(buff, "stacks_changed", [1, 2])
	assert_signal_emit_count(buff, "worn_off", 1)

func test_apply_buff_with_custom_stacks():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity, 0, 12)
	assert_not_null(BuffManager.get_buff(Enum.Buff.unit_test_buff_refresh_stack, entity))
	assert_eq(buff.stacks, 12)

func test_apply_buff_with_custom_duration():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity, 6500, 0)
	assert_not_null(BuffManager.get_buff(Enum.Buff.unit_test_buff_refresh_stack, entity))
	assert_eq(int(buff.duration_dt * 1000), 6500)

func test_apply_and_reapply_buff_duration_none():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_no_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_no_stack, entity, entity)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms)
	assert_eq(buff.stacks, 1)

func test_apply_and_reapply_buff_duration_refresh():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms)
	assert_eq(buff.stacks, 2)

func test_apply_and_reapply_buff_duration_refresh_with_custom_duration():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity, 6500)
	assert_eq(int(buff.duration_dt * 1000), 6500)
	assert_eq(buff.stacks, 2)

func test_apply_and_reapply_buff_duration_refresh_with_custom_stacks():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_refresh_stack, entity, entity, 0, 12)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms)
	assert_eq(buff.stacks, 13)

func test_apply_and_reapply_buff_duration_increase():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms * 2)
	assert_eq(buff.stacks, 2)

func test_apply_and_reapply_buff_duration_increase_with_custom_duration():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity, 6500)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms + 6500)
	assert_eq(buff.stacks, 2)

func test_apply_and_reapply_buff_duration_increase_with_custom_stacks():
	var buff = BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity)
	BuffManager.apply(Enum.Buff.unit_test_buff_increase_stack, entity, entity, 0, 12)
	assert_eq(int(buff.duration_dt * 1000), buff.buff_definition.duration_ms * 2)
	assert_eq(buff.stacks, 13)

func test_apply_and_reapply_buff_duration_rolling():
	pending()

func test_apply_and_reapply_buff_duration_rolling_complex():
	pending()
