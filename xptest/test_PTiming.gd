extends GutTest

signal tick_cb
signal end_cb

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

func test_tick_until_calls_tick_cb():
	var tick_cb = Callable(self, "_tick_cb")
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	PTiming.tick_until(100, 500, tick_cb, end_cb)
	simulate(PTiming, 60, 0.016666)
	assert_signal_emitted(self, "tick_cb")

func test_tick_until_calls_end_cb():
	var tick_cb = Callable(self, "_tick_cb")
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	PTiming.tick_until(100, 500, tick_cb, end_cb)
	simulate(PTiming, 60, 0.016666)
	assert_signal_emitted(self, "end_cb")

func test_tick_until_is_cancellable():
	var tick_cb = Callable(self, "_tick_cb")
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	var ref = PTiming.tick_until(100, 500, tick_cb, end_cb)
	ref.fn.call(ref.job)
	simulate(PTiming, 60, 0.016666)
	assert_signal_not_emitted(self, "end_cb")

func test_tick_until_cleaned_up():
	var tick_cb = Callable(self, "_tick_cb")
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	var before_count = PTiming.tick_until_jobs.size()
	PTiming.tick_until(100, 500, tick_cb, end_cb)
	simulate(PTiming, 60, 0.016666)
	assert_eq(before_count, PTiming.tick_until_jobs.size())


func test_delay_calls_end_cb():
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	PTiming.delay(100, end_cb)
	simulate(PTiming, 60, 0.016666)
	assert_signal_emitted(self, "end_cb")

func test_delay_is_cancellable():
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	var ref = PTiming.delay(100, end_cb)
	ref.fn.call(ref.job)
	simulate(PTiming, 60, 0.016666)
	assert_signal_not_emitted(self, "end_cb")

func test_delay_cleaned_up():
	var end_cb = Callable(self, "_end_cb")
	watch_signals(self)
	var before_count = PTiming.delay_jobs.keys().size()
	PTiming.delay(100, end_cb)
	simulate(PTiming, 60, 0.016666)
	assert_eq(before_count, PTiming.delay_jobs.keys().size())



func _tick_cb(_job):
	emit_signal("tick_cb")

func _end_cb(_job):
	emit_signal("end_cb")
