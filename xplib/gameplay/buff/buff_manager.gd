extends Node


signal entity_buffs_changed(entity, buff_list)

var buffs = []
var buff_gid_map = {}

func _process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	for buff in buffs:
		var def: BuffDefinition = buff.buff_definition
		buff.tick_dt -= delta
		if buff.tick_dt <= 0:
			buff.tick_dt += float(def.tick_interval_ms) / 1000.0
			tick(buff)
		if def.duration_type == Enum.BuffDuration.rolling:
			for stack_obj in buff.rolling_stacks:
				if now >= stack_obj.start_time + def.reapply_duration_ms:
					remove_rolling_stacks(buff, stack_obj)
		buff.duration_dt -= delta
		if buff.duration_dt <= 0:
			wear_off(buff)


# not currently checked or used
func can_apply(buff_type: int, creator, attached_to_target) -> bool:
	var def: BuffDefinition = BuffData.data.get(buff_type)
	var result = true
	if def.can_apply_to_gid_fn:
		result = def.can_apply_to_gid_fn.call(def, creator, attached_to_target)
	return result


func apply(buff_type: int, creator, attached_to, duration_ms: int = 0, stacks: int = 0) -> Buff:
	var def: BuffDefinition = BuffData.data.get(buff_type)
	var buff = get_buff(buff_type, attached_to)
	
	if buff:
		reapply_buff(buff, duration_ms, stacks)
	else:
		buff = Buff.new()
		buff.buff_type = buff_type
		buff.buff_definition = def
		assert(creator.gid, 'creator GID is null')
		buff.creator_gid = creator.gid
		buff.creator = creator
		assert(attached_to.gid, 'attached_to GID is null')
		buff.attached_to_gid = attached_to.gid
		buff.attached_to = attached_to
		if stacks:
			buff.stacks = stacks
		else:
			buff.stacks = def.default_stacks
		buff.start_time = Time.get_ticks_msec()
		var duration
		if duration_ms:
			duration = float(duration_ms) / 1000.0
		else:
			duration = float(def.duration_ms) / 1000.0
		buff.tick_dt = float(def.tick_interval_ms) / 1000.0
		buff.duration_dt = duration
		if buff.buff_definition.duration_type == Enum.BuffDuration.rolling:
			add_rolling_stacks(buff, buff.stacks)
#		prints('duration', duration, 'tick', buff.tick_dt)
		buff.end_time = Time.get_ticks_msec() + duration_ms

		_add_buff_to_map(buff, attached_to)
		if buff.buff_definition.apply_fn:
			buff.buff_definition.apply_fn.call(buff, buff.buff_definition)
		if buff.buff_definition.update_stacks_fn:
			buff.buff_definition.update_stacks_fn.call(buff, buff.buff_definition, 0, buff.stacks)
	emit_signal("entity_buffs_changed", attached_to, _get_all_buffs(attached_to))
	return buff


func _add_buff_to_map(buff: Buff, attached_to):
	buffs.push_back(buff)
	var buff_list = buff_gid_map.get(attached_to.gid)
	if !buff_list:
		buff_list = {}
	buff_list[buff.buff_type] = buff
	buff_gid_map[attached_to.gid] = buff_list


func _remove_buff_from_map(buff: Buff):
	buffs.erase(buff)
	var buff_list = buff_gid_map.get(buff.attached_to.gid)
	if buff_list:
		buff_list.erase(buff.buff_type)


func _clear_all_buffs():
	for buff in buffs:
		buff.free()
	buffs.clear()
	buff_gid_map = {}


func _get_all_buffs(attached_to):
	return buff_gid_map.get(attached_to.gid)


func add_rolling_stacks(buff: Buff, stacks: int):
	var stack_obj = {
		"start_time": Time.get_ticks_msec(),
		"stacks": stacks,
	}
	buff.rolling_stacks.push_back(stack_obj)


func remove_rolling_stacks(buff: Buff, stack_obj):
	change_stacks(buff, -stack_obj.stacks)
	buff.rolling_stacks.erase(stack_obj)


func get_buff(buff_type: int, attached_to):
	var buff_list = buff_gid_map.get(attached_to.gid)
	if !buff_list:
		return null
	var buff = buff_list.get(buff_type)
	return buff

func reapply_buff(buff: Buff, duration_ms: int = 0, stacks: int = 0):
	var def = buff.buff_definition
	stacks = PMisc.cq([stacks, def.reapply_stacks])

	match def.duration_type:
		Enum.BuffDuration.none:
			return
		Enum.BuffDuration.increase:
			change_stacks(buff, stacks)
			var old_duration = buff.duration_dt
			var duration_added = PMisc.cq([duration_ms, def.reapply_duration_ms])
			buff.duration_dt += float(duration_added) / 1000.0
			if def.max_possible_duration_ms:
				buff.duration_dt = min(buff.duration_dt, def.max_possible_duration_ms / 1000.0)
			var diff = buff.duration_dt - old_duration
			buff.end_time += diff
		Enum.BuffDuration.refresh, Enum.BuffDuration.rolling:
			change_stacks(buff, stacks)
			var duration_added = PMisc.cq([duration_ms, def.reapply_duration_ms])
			var diff = float(duration_added) / 1000.0 - buff.duration_dt
			buff.duration_dt = float(duration_added) / 1000.0
			buff.end_time += diff
			if def.duration_type == Enum.BuffDuration.rolling:
				add_rolling_stacks(buff, stacks)

	buff.emit_signal("reapplied")

func wear_off_stacks(buff: Buff, count: int):
	change_stacks(buff, -count)
	if buff.stacks <= count:
		return wear_off(buff)

func change_stacks(buff: Buff, count: int):
	var old_stacks = buff.stacks
	buff.stacks += count
	if buff.buff_definition.update_stacks_fn:
		buff.buff_definition.update_stacks_fn.call(buff, buff.buff_definition, old_stacks, buff.stacks)
	buff.emit_signal("stacks_changed", old_stacks, buff.stacks)

func tick(buff: Buff):
	if buff.buff_definition.tick_fn:
		buff.buff_definition.tick_fn.call(buff, buff.buff_definition)
	buff.emit_signal("ticked")

func wear_off(buff: Buff):
	var attached_to = buff.attached_to
	if buff.buff_definition.wear_off_fn:
		buff.buff_definition.wear_off_fn.call(buff, buff.buff_definition)
	buff.emit_signal("worn_off")
	_remove_buff_from_map(buff)
	buff.queue_free()
	emit_signal("entity_buffs_changed", attached_to, _get_all_buffs(attached_to))
