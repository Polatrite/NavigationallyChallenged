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
	var title: String
	var desc: String
	match kind:
		"door1":
			title = "Door Sensor Array v1"
			desc = "Lets you see completely normal doors."
		"door2":
			title = "Door Sensor Array v2"
			desc = "Lets you see doors that teleport you 1 room."
		"door3":
			title = "Door Sensor Array v3"
			desc = "Lets you see doors that teleport you 2 rooms."
		"bomb":
			title = "Tiny Blaster Cannon"
			desc = "Fires nearly useless bomb blasts that can destroy\nonly pathetic walls."
		"boots":
			title = "Too-Springy Legs"
			desc = "Allows you to jump... indefinitely!"
	$Title.text = title
	$Desc.text = desc
	$Title.visible = true
	$Desc.visible = true
	await get_tree().create_timer(8.0).timeout
	$Title.visible = false
	$Desc.visible = false

func _on_unlock_granted(kind: String):
	write_label()
