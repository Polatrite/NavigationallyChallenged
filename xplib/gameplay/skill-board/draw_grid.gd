@tool
extends Control

const GRID_SIZE = 32
@export var drawing_enabled: bool = true


@export var grid_minor_tickmark: int = 100
@export var grid_major_tickmark: int = 300

func _draw():
	if drawing_enabled: 
		var size = get_viewport_rect().size  * get_parent().get_node("camera_2d").zoom / 2
		var cam: Vector2 = get_parent().get_node("camera_2d").position
		global_position = cam.snapped(Vector2(GRID_SIZE,GRID_SIZE))
		for i in range(int((cam.x - size.x) / GRID_SIZE) - 1, int((size.x + cam.x) / GRID_SIZE) + 1):
			draw_line(Vector2(i * GRID_SIZE, cam.y + size.y + 100), Vector2(i * GRID_SIZE, cam.y - size.y - 100), "000000")
		for i in range(int((cam.y - size.y) / GRID_SIZE) - 1, int((size.y + cam.y) / GRID_SIZE) + 1):
			draw_line(Vector2(cam.x + size.x + 100, i * GRID_SIZE), Vector2(cam.x - size.x - 100, i * GRID_SIZE), "000000")

func _process(delta):
	queue_redraw()
