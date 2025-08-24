extends Node

func tryget(dict: Dictionary, key, default = null):
	if dict.has(key):
		return dict.get(key)
	return default

func array_get(array: Array, thing):
	var i = array.find(thing)
	if i == -1:
		return null
	return array[i]

func array_get_rand(array: Array):
	var r = randi()
	var res = r % array.size()
	return array[res]

func array_get_randi(array: Array):
	return randi() % array.size()

func dict_get_randi(dict: Dictionary):
	return randi() % dict.size()
	
func dict_get_rand(dict: Dictionary):
	var i = randi() % dict.size()
	var key = dict.keys()[i]
	return [key, dict[key]]

func array_get_unique_rands(array: Array, count: int):
	assert(count <= array.size(), 'array_get_unique_rands tried to get more unique values than the array has')
	array = array.duplicate()
	var chosen = []
	var index
	for _i in range(count):
		index = array_get_randi(array)
		chosen.push_back(array[index])
		array.remove_at(index)
		index = null
	return chosen

func array_is_samey(a: Array, b: Array):
	if(a.size() != b.size()):
		return false
	for t in a:
		if(!b.has(t)):
			return false
	return true

func array_swap(array: Array, index_1: int, index_2: int):
	var temp = array[index_1]
	array[index_1] = array[index_2]
	array[index_2] = temp

func array_first(filter_function: Callable, candidate_array: Array):
	push_error("PList.array_first() deprecated, use Array.front()")

# Partition an array into lists of n items each at offsets step apart
func partition(array: Array, width: int) -> Array:
		var acc = []
		for i in range(array.size() - (width - 1)):
			var part = array.slice(i, i + (width - 1))
			acc.push_back(part)
		return acc

# Pull a subset of keys from a dictionary and return it as a new dict
func select_keys(dict: Dictionary, keys: Array) -> Dictionary:
	var sub_dict = {}
	for k in keys:
		if dict.has(k):
			sub_dict[k] = dict[k]
	return sub_dict


func array_union(a1: Array, a2: Array) -> Array:
	var aj = []
	aj.append_array(a1)
	aj.append_array(a2)
	aj = array_get_unique_values_only(a1)
	return aj


func array_get_unique_values_only(arr: Array) -> Array:
	var aj = []
	for item in arr:
		if aj.find(item) == -1:
			aj.push_back(item)
	return aj
