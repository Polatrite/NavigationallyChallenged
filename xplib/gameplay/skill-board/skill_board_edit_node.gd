extends Control

signal skill_node_clicked(this_node)
signal request_show_context_menu(this_node)
@export var resource: SkillNodeResource


func set_resource(res: SkillNodeResource):
	print('set_resource ', res.position)
	resource = res
	var max_size = Vector2(0,0)
	if res.background_texture:
		$background.texture = res.background_texture
	var rect: Rect2 = $background.get_rect()
	max_size.x = rect.size.x
	max_size.y = rect.size.y
	if res.foreground_texture:
		$foreground.texture = res.foreground_texture
	rect = $foreground.get_rect()
	max_size.x = max(rect.size.x, max_size.x)
	max_size.y = max(rect.size.y, max_size.y)
	size = max_size
	scale = res.scale
	global_position = res.position - size / 2
	queue_redraw()


func get_center_pos():
	return global_position + size / 2


func set_node_position(pos: Vector2):
	resource.position = pos
	global_position = pos


func add_link(dest_id: int):
	resource.links.push_back(dest_id)


func create_new_resource(next_id: int, links: Array[int] = []):
	assert(next_id, 'SkillBoardNode requires a skill_id to be passed as next_id, but received none')
	resource = SkillNodeResource.new()
	resource.skill_id = next_id
	resource.links = links
	set_resource(resource)


func handle_context_menu():
	prints('handle_context_menu', self)
	emit_signal("request_show_context_menu", self)


func _on_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			handle_context_menu()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			emit_signal("skill_node_clicked", self)


func _get_drag_data(at_position):
	return self



