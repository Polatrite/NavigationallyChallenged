extends Node

var delay_jobs = {}
var _delay_counter = 1
var tick_until_jobs = []

func wait(delay, signal_name = "timeout"):
	await get_tree().create_timer(delay).signal_name

## Create a one-shot job that emits tick callbacks and end callbacks.
func tick_until(tick_int_ms: int, duration_ms: int, tick_cb: Callable, end_cb: Callable, tick_on_end: bool = false):
	var job = {
		"tick_int_ms": tick_int_ms,
		"duration_ms": duration_ms,
		"tick_cb": tick_cb,
		"end_cb": end_cb,
		"time_elapsed_ms": 0,
		"tick_on_end": tick_on_end,
	}
	tick_until_jobs.push_back(job)
	return {
		"fn": Callable(self, "cancel_tick_until"),
		"job": job,
	}

func cancel_tick_until(job):
	tick_until_jobs.erase(tick_until_jobs.find(job))

## Create a one-shot delay job that emits an end callback.
func delay(duration_ms: int, end_cb: Callable):
	var job = {
		"id": _delay_counter,
		"duration_ms": duration_ms,
		"end_cb": end_cb,
		"time_elapsed_ms": 0,
	}
	delay_jobs[_delay_counter] = job
	_delay_counter += 1 # will eventually wrap around
	return {
		"fn": Callable(self, "cancel_delay"),
		"job": job,
	}

func cancel_delay(job):
	delay_jobs.erase(job.id)

func _process(delta):
	for i in range(tick_until_jobs.size()-1, -1, -1):
		var job = tick_until_jobs[i]
		var old_time = job.time_elapsed_ms
		job.time_elapsed_ms += delta * 1000
		if int(job.time_elapsed_ms) / int(job.tick_int_ms) != int(old_time) / int(job.tick_int_ms):
			job.tick_cb.call(job)
		if job.time_elapsed_ms >= job.duration_ms:
			if job.tick_on_end:
				job.tick_cb.call(job)
			job.end_cb.call(job)
			tick_until_jobs.erase(i)

	for key in delay_jobs.keys():
		var job = delay_jobs[key]
		job.time_elapsed_ms += delta * 1000
		if job.time_elapsed_ms >= job.duration_ms:
			job.end_cb.call(job)
			delay_jobs.erase(job.id)
