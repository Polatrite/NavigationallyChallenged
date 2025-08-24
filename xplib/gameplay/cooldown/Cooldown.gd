class_name Cooldown
extends Node

signal wear_off #TODO: what is emitted?
signal tick_second #TODO: what is emitted?
var owner_gid: int = -1
var cooldown_type: int = -1
var start_time: int = 0
var end_time: int = 0
var duration_dt: float = 0


func init_start_and_end(_owner_gid: int, _cooldown_type: int, _duration_ms: int):
	owner_gid = _owner_gid
	if(!start_time):
		start_time = Time.get_ticks_msec()
	cooldown_type = _cooldown_type
	duration_dt = float(_duration_ms) / 1000.0
	end_time = Time.get_ticks_msec() + _duration_ms

