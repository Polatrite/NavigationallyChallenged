class_name Buff
extends Node

signal reapplied()
signal ticked()
signal stacks_changed(new_stacks, old_stacks)
signal worn_off()

var buff_type: int # Enum.Buff.<type>
var buff_definition: BuffDefinition
var creator
var attached_to
var stacks: int = 0
var rolling_stacks: Array
var creator_gid: int = -1
var attached_to_gid: int = -1
var start_time: float = 0
var end_time: float = 0
var duration_dt: float = 0
var tick_dt: float = 0
