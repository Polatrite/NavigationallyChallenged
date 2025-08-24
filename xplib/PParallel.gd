extends Object
class_name PParallel

signal completed

var queued_coroutines: Array[Dictionary]
var total_count: int
var completed_count: int


func append(object: Object, call_method: StringName, params: Array, complete_signal: StringName):
	queued_coroutines.append({'object': object, 'call_method': call_method, 'params': params, 'complete_signal': complete_signal})


func run_all():
	total_count = queued_coroutines.size()
	for routine in queued_coroutines:
		var object:Object = routine['object']
		var params:Array = routine['params']
		var call_method:StringName = routine['call_method']
		var complete_signal:StringName = routine['complete_signal']
		object.callv(call_method, params)
		object.connect(complete_signal, _on_completed)


func _on_completed(a = null, b = null, c = null, d = null, e = null, f = null, g = null): # I don't know how else to allow but ignore parameters
	completed_count = completed_count + 1
	if completed_count == total_count:
		completed.emit()
