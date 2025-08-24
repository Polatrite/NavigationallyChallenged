extends Node


var started_messages = {}

class PLogMessage:
	var _message = ""
	var start_time

	func _init() -> void:
		start_time = Time.get_ticks_usec()

	func print_end(msg: String, include_timestamp: bool = false):
		if include_timestamp:
			var end_time = Time.get_ticks_usec()
			print(str(_message, msg, ' (', (end_time - start_time), 'μs)'))
		else:
			print(str(_message, msg))

func print_start(msg: String) -> PLogMessage:
	var message = PLogMessage.new()
	message._message = msg
	return message

func print_init(msg: String) -> PLogMessage:
	return print_start(str('[INIT] ', msg, '... '))
