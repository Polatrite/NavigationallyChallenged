extends Camera2D

signal room_changed(room_x, room_y)
@export var player: CharacterBody2D
var half_screen = Vector2(Constants.screen_width,Constants.screen_height) / 2
var last_room = Vector2(-999, -999)

func _process(delta: float) -> void:
	var player_pos = player.global_position - half_screen
	var x = snapped(player_pos.x, Constants.screen_width)
	var y = snapped(player_pos.y, Constants.screen_height)
	var room_x = x / Constants.screen_width
	var room_y = y / Constants.screen_height
	global_position = Vector2(x, y)
	if last_room.x != room_x or last_room.y != room_y:
		emit_signal("room_changed", room_x, room_y)
		last_room = Vector2(room_x, room_y)
