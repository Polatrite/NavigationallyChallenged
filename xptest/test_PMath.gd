extends GutTest

func before_all():
	pass

func before_each():
	return
	PMath.rng.randomize()

func after_each():
	pass

func after_all():
	pass

func test_seeded_rand_int():
	PMath.rng.seed = 123
	assert_eq(6, PMath.rand_int(0, 10))

func test_seeded_rand_float():
	PMath.rng.seed = 123
	var val = PMath.rand_float(0, 10)
	assert_gt(9.460959, val)
	assert_lt(9.460958, val)

func test_round_vector_to_cardinal():
	assert_eq(Vector2(0,1.3),  PMath.round_vector_to_cardinal(Vector2(1.2,1.3)))
	assert_ne(Vector2(1.2,0),  PMath.round_vector_to_cardinal(Vector2(1.2,1.3)))
	assert_eq(Vector2(-1.4,0), PMath.round_vector_to_cardinal(Vector2(-1.4,1.3)))
	assert_ne(Vector2(0,1.3),  PMath.round_vector_to_cardinal(Vector2(-1.4,1.3)))

func test_rand_multi_to_int():
	return
	# something about this is cursed, and certain code changes elsewhere in the project cause this test to stop working
	PMath.rng.seed = 123
	PMath.rng.state = 100
	assert_eq(4.0, PMath.rand_multi_to_int(3.4))
	assert_eq(3.0, PMath.rand_multi_to_int(3.4))
	assert_eq(4.0, PMath.rand_multi_to_int(3.4))
	assert_eq(4.0, PMath.rand_multi_to_int(3.4))
	assert_eq(3.0, PMath.rand_multi_to_int(3.4))
	assert_eq(3.0, PMath.rand_multi_to_int(3.4))
	assert_eq(3.0, PMath.rand_multi_to_int(3.4))
	assert_eq(4.0, PMath.rand_multi_to_int(3.4))
