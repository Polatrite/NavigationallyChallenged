extends GutTest

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

func test_coalesce_int():
	var val = 5
	assert_eq(PMisc.coalesce([null, val]), val)
	assert_eq(PMisc.cq([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, 0, val]), 0)

func test_coalesce_string():
	var val = 'five'
	assert_eq(PMisc.coalesce([null, val]), val)
	assert_eq(PMisc.cq([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, 0, val]), 0)

func test_coalesce_array():
	var val = ['five5']
	assert_eq(PMisc.coalesce([null, val]), val)
	assert_eq(PMisc.cq([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, val]), val)
	assert_eq(PMisc.null_coalesce([null, 0, val]), 0)

func test_coalesce_mixed():
	var val = 5
	assert_eq(PMisc.coalesce([null, val, 'five']), val)
	assert_eq(PMisc.cq([null, val, 'five']), val)
	assert_eq(PMisc.null_coalesce([null, val, 'five']), val)
	assert_eq(PMisc.null_coalesce([null, 0, val]), 0)
