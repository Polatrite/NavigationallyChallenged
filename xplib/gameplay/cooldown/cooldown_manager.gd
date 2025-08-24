extends Node

var entity_map = {}
var cooldowns = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for i in range(cooldowns.size()-1, -1, -1):
		var cd = cooldowns[i]
		var last_second = floor(cd.duration_dt)
		cd.duration_dt -= delta
		if(floor(cd.duration_dt) < last_second):
			cd.emit_signal("tick_second", cd.cooldown_type)
		if(cd.duration_dt <= 0):
			cd.emit_signal("wear_off", cd.cooldown_type)
			remove_cooldown_by_ref(cd)


func add_cooldown(gid: int, cooldown_type: int, duration_ms: int) -> Cooldown:
	if(!entity_map.has(gid)):
		entity_map[gid] = {}

	var cd = entity_map[gid].get(cooldown_type)
	if(cd):
		cd.init_start_and_end(gid, cooldown_type, duration_ms)
	else:
		cd = Cooldown.new()
		entity_map[gid][cooldown_type] = cd
		cooldowns.append(cd)
		cd.init_start_and_end(gid, cooldown_type, duration_ms)
	return cd


func remove_cooldown_by_ref(cd: Cooldown):
	entity_map[cd.owner_gid].erase(cd.cooldown_type)
	cooldowns.erase(cd)
	cd.queue_free()


func remove_cooldown_by_type(gid: int, cooldown_type: int):
	var cd = entity_map[gid][cooldown_type]
	remove_cooldown_by_ref(cd)


func get_cooldown_by_type(gid: int, cooldown_type: int) -> Cooldown:
	if(!entity_map.has(gid)):
		return null
	return entity_map[gid].get(cooldown_type)


func has_cooldown(gid: int, cooldown_type: int) -> bool:
	return !!get_cooldown_by_type(gid, cooldown_type)


func _clear_all_cooldowns():
	for cd in cooldowns:
		cd.free()
	cooldowns.clear()
	entity_map = {}
