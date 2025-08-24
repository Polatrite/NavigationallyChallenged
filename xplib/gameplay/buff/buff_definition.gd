class_name BuffDefinition
extends Node

var pretty_name: String = ''
var buff_type: int # Enum.Buff.<type>
var duration_ms: int = 0
var infinite_duration: bool = false
var show_on_ui: bool = true
var removed_on_death: bool = true
var default_stacks: int = 1
var duration_type: int = Enum.BuffDuration.none

# for stack_type != none
var reapply_stacks: int
var reapply_duration_ms: int
var max_possible_duration_ms: int

# (def: BuffDefinition, creator, attached_to)
var can_apply_to_gid_fn: Callable

# (buff: Buff, def: BuffDefinition)
var apply_fn: Callable

# (buff: Buff, def: BuffDefinition, old_stacks: int, new_stacks: int)
var update_stacks_fn: Callable

# (buff: Buff, def: BuffDefinition)
var tick_fn: Callable
var tick_interval_ms: int

# (buff: Buff, def: BuffDefinition)
var wear_off_fn: Callable

func _init(params: Dictionary) -> void:
	for key in params:
		self[key] = params[key]
	if duration_type != Enum.BuffDuration.none:
		if !reapply_stacks:
			reapply_stacks = default_stacks
		if !reapply_duration_ms:
			reapply_duration_ms = duration_ms
