extends Control

func _ready() -> void:
	SignalBus.connect("pickup_collected", _on_pickup_collected)
	SignalBus.connect("unlock_granted", _on_unlock_granted)

func write_label():
	var unlock_str = ""
	var first = true
	for key in Global.unlocks.keys():
		if Global.unlocks[key] == false:
			continue
		if !first:
			unlock_str += ", "
		unlock_str += key
		first = false
	$Label.text = str("Hearts: ", Global.hearts, "/", floor(Global.max_hearts), "\n", "Coins: ", Global.coins, "\nUnlocks: ", unlock_str)

func _on_pickup_collected(kind: String):
	write_label()

func _on_unlock_granted(kind: String):
	write_label()
