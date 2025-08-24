extends GutTest

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

func test_tryget():
	var dict = {
		"has_bool": true,
		"has_int": 5,
		"has_string": 'five',
		"has_array": ['five5'],
		"has_dict": {},
		"has_nothing": null,
	}
	assert_eq(PList.tryget(dict, "has_bool"), true)
	assert_eq(PList.tryget(dict, "has_int"), 5)
	assert_eq(PList.tryget(dict, "has_string"), 'five')
	assert_eq(PList.tryget(dict, "has_array"), ['five5'])
	assert_eq(PList.tryget(dict, "has_dict"), dict["has_dict"])
	assert_eq(PList.tryget(dict, "has_nothing"), null)
	assert_eq(PList.tryget(dict, "missing_entirely"), null)

func test_array_get_rand():
	pending()

func test_array_get_randi():
	pending()

func test_dict_get_rand():
	pending()

func test_dict_get_randi():
	pending()

func test_array_get_unique_rands():
	pending()

func test_array_is_samey():
	var arr = [1, 2, 3, 4, 5]
	var arr_same = [1, 2, 3, 4, 5]
	var arr_backwards = [3, 4, 1, 5, 2]
	var arr_too_many = [5, 4, 3, 2, 1, 0]
	var arr_too_few = [5, 4, 3, 2]
	var arr_diff = ['five', 1, 2, 3, 4]
	assert_true(PList.array_is_samey(arr, arr))
	assert_true(PList.array_is_samey(arr, arr_same))
	assert_true(PList.array_is_samey(arr, arr_backwards))
	assert_false(PList.array_is_samey(arr, arr_too_many))
	assert_false(PList.array_is_samey(arr, arr_too_few))
	assert_false(PList.array_is_samey(arr, arr_diff))

func test_partition():
	var arr = [1, 2, 3, 4, 5]
	assert_true(PList.array_is_samey(PList.partition(arr, 2), [[1, 2], [2, 3], [3, 4], [4, 5]]))
	assert_true(PList.array_is_samey(PList.partition(arr, 1), [[1], [2], [3], [4], [5]]))

func test_array_filter():
	pending()

func test_array_map():
	pending()

func test_array_reduce():
	pending()
