extends Node

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	return
	rng.randomize()

func rand_int(minv: int = 0, maxv: int = 1) -> int:
	return rng.randi_range(minv, maxv)

func rand_float(minv: float = 0, maxv: float = 1) -> float:
	return rng.randf_range(minv, maxv)

func rand_multi_to_int(multi: float) -> int:
	var base = floor(multi)
	base += 1 if (randf() <= fmod(multi, 1)) else 0
	return base

func randf_lucky(times: float):
	times = rand_multi_to_int(times)
	var highest = 0
	for i in times:
		highest = max(rng.randf(), highest)
	return highest

func randf_unlucky(times: float):
	times = rand_multi_to_int(times)
	var lowest = 0
	for i in times:
		lowest = min(rng.randf(), lowest)
	return lowest

func vector_get_random_direction():
	var d = randi() % 4 + 1
	match d:
		1:
			return Vector2.LEFT
		2:
			return Vector2.RIGHT
		3:
			return Vector2.UP
		4:
			return Vector2.DOWN

func round_vector_to_cardinal(vectIn: Vector2):
	var vect = Vector2(vectIn)
	if max(abs(vect.x), abs(vect.y)) == abs(vect.x):
		vect.y = 0
	else:
		vect.x = 0
	return vect

func snap_vector_to_grid(vector: Vector2, grid_size = 16):
	return vector.snapped(Vector2(grid_size,grid_size)) - Vector2(grid_size/2,grid_size/2)

func between(input, minv, maxv, inclusive = true): 
	if inclusive:
		return input >= minv && input <= maxv
	else:
		return input > minv && input < maxv

func map_to_percent(min_num: float, max_num: float, x: float) -> float:
	return (x - min_num) / max_num


func get_range_stepped_value(min_range: float, max_range: float, num_steps: int, curr_step: int):
	return min_range - ((min_range - max_range) / (num_steps - 1.0) * (curr_step - 1.0))
