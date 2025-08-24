extends Camera2D

@export var player: CharacterBody2D
var half_screen = Vector2(Constants.screen_width,Constants.screen_height) / 2

func _process(delta: float) -> void:
	var player_pos = player.global_position - half_screen
	var x = snapped(player_pos.x, Constants.screen_width)
	var y = snapped(player_pos.y, Constants.screen_height)
	global_position = Vector2(x, y)
