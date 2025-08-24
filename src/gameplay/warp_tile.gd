@tool
extends Area2D

@export_enum("left1", "left2", "left3", "right1", "right2", "right3", "up1", "up2", "up3", "down1", "down2", "down3") var kind: String

var dir_map = {
	Vector2.LEFT: preload("res://assets/Oryx 16-bit Fantasy/Sliced/world_24x24/oryx_16bit_fantasy_world_1832.png"),
	Vector2.DOWN: preload("res://assets/Oryx 16-bit Fantasy/Sliced/world_24x24/oryx_16bit_fantasy_world_1831.png"),
	Vector2.RIGHT: preload("res://assets/Oryx 16-bit Fantasy/Sliced/world_24x24/oryx_16bit_fantasy_world_1775.png"),
	Vector2.UP: preload("res://assets/Oryx 16-bit Fantasy/Sliced/world_24x24/oryx_16bit_fantasy_world_1774.png"),
}
var color_map = {
	1: Color.RED,
	2: Color.WHITE,
	3: Color.LIME_GREEN,
}

func _ready() -> void:
	setup_sprite()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		setup_sprite()

func setup_sprite():
	var result = get_teleport_dest()
	#print(result)
	$Sprite2D.texture = dir_map[result[0]]
	$Sprite2D.modulate = color_map[result[1]]

func get_teleport_dest():
	var dir: Vector2
	var dist = 0
	if kind.begins_with("left"):
		dir = Vector2.LEFT
		dist = int(kind[4])
	elif kind.begins_with("right"):
		dir = Vector2.RIGHT
		dist = int(kind[5])
	elif kind.begins_with("up"):
		dir = Vector2.UP
		dist = int(kind[2])
	elif kind.begins_with("down"):
		dir = Vector2.DOWN
		dist = int(kind[4])
	var warp_offset = dir * Vector2(56,56)
	var teleport_dest = dir * dist * Vector2(408, 264) + warp_offset  #Constants.screen_width
	return [dir, dist, teleport_dest]


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var result = get_teleport_dest()
		printt(kind, result[0], result[1], result[2])
		body.global_position += result[2]
		body.movement_locked = 0.15 * result[1]
