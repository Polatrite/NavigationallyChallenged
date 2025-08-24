extends Node

enum OperatingPlatform {
	WINDOWS = 1,
	LINUX = 2,
	ANDROID = 3,
	IOS = 4,
}

var platform = OperatingPlatform.WINDOWS
var is_mobile = false
var is_tablet = false
var is_desktop = false


func _ready() -> void:
	match OS.get_name():
		"Android":
			platform = OperatingPlatform.ANDROID
			is_mobile = true
		"iOS":
			platform = OperatingPlatform.IOS
			is_mobile = true
		_:
			platform = OperatingPlatform.WINDOWS
			is_desktop = true
