extends Node2D

func _ready() -> void:
	SignalBus.connect("unlock_granted", _on_unlock_granted)

func _on_unlock_granted(kind):
	match kind:
		"door1":
			var tiles = get_tree().get_nodes_in_group("warp-1")
			for tile in tiles:
				tile.setup_sprite()
		"door2":
			var tiles = get_tree().get_nodes_in_group("warp-2")
			for tile in tiles:
				tile.setup_sprite()
		"door3":
			var tiles = get_tree().get_nodes_in_group("warp-3")
			for tile in tiles:
				tile.setup_sprite()
