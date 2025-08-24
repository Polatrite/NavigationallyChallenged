@tool
extends Control

const SAVE_DATA_FILE = "user://skill_board.tres"
var is_dragging_camera: bool = false
var resource: SkillBoardResource
var _next_id: int = 1000
var skill_node = preload("res://xplib/gameplay/skill-board/skill_board_edit_node.tscn")
var edit_context_menu = preload("res://xplib/gameplay/skill-board/edit_node_context_menu.tscn")
var is_linking: bool = false
var link_origin_node: Control
var skill_node_by_id: Dictionary = {}
var skill_node_scene_by_id: Dictionary = {}


func _ready():
	var save_data = load_skill_board()
	if !save_data:
		save_data = init_skill_board()
	


func _process(delta):
	var viewport = get_viewport().size


func load_skill_board():
	print('load_skill_board')
	if !ResourceLoader.exists(SAVE_DATA_FILE):
		return null
	var load_result = ResourceLoader.load(SAVE_DATA_FILE, "SkillBoardResource", ResourceLoader.CACHE_MODE_IGNORE)
	print('[INFO] Data loaded from ', SAVE_DATA_FILE, ' ', load_result)
	if not(load_result is SkillBoardResource):
		return null
	resource = load_result
	for node in resource.nodes:
		hydrate_node(node)
		_next_id = max(_next_id, node.skill_id)
	return load_result


func save_skill_board():
	print('save_skill_board')
	var result = ResourceSaver.save(resource, SAVE_DATA_FILE)
	if result == OK:
		print('[INFO] Data saved to ', SAVE_DATA_FILE)
		return
	printerr('[ERROR] Unable to save data to ', SAVE_DATA_FILE, ', error: ', result)


func init_skill_board():
	print('init_skill_board')
	resource = SkillBoardResource.new()
	resource.name = "Default"
	save_skill_board()
	return resource


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_skill_board()


func _on_gui_input(event):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_dragging_camera = event.is_pressed()
			print('middle mouse, is_dragging_camera turned ', is_dragging_camera)
	elif event is InputEventMouseMotion:
		if is_dragging_camera:
			$camera_2d.position += event.relative
		else:
			var drag_data = get_viewport().gui_get_drag_data()
			if drag_data:
				drag_data.global_position = get_global_mouse_position() + Vector2(4,4)
				queue_redraw()
				print(drag_data)


func _draw():
	var origin_node: Control
	var dest_node: Control
	for node in resource.nodes:
		for link in node.links:
			origin_node = skill_node_scene_by_id[node.skill_id]
			dest_node = skill_node_scene_by_id[link]
			draw_line(origin_node.get_center_pos(), dest_node.get_center_pos(), Color.WHEAT, 3, true)


func get_snap_pixels():
	var val = $camera_2d/hud/v_box_container/edit_snap_pixels.value
	return Vector2(val, val)


func get_next_id():
	_next_id += 1
	return _next_id


func get_camera_center() -> Vector2:
	return $camera_2d.position


func _on_btn_center_pressed():
	var tween = create_tween()
	tween.tween_property($camera_2d, "position", Vector2.ZERO, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _on_btn_add_node_pressed():
	var node = skill_node.instantiate()
	node.connect("request_show_context_menu", _on_request_show_context_menu)
	node.connect("skill_node_clicked", _on_skill_node_clicked)
	node.create_new_resource(get_next_id())
	node.set_node_position(get_camera_center().snapped(get_snap_pixels()))
	node.set_drag_forwarding(Callable(), _can_drop_data, _drop_data)
	resource.nodes.push_back(node.resource)
	skill_node_by_id[node.resource.skill_id] = node.resource
	skill_node_scene_by_id[node.resource.skill_id] = node
	add_child(node)
	queue_redraw()


func hydrate_node(node_resource: SkillNodeResource):
	var node = skill_node.instantiate()
	node.set_resource(node_resource)
	node.connect("request_show_context_menu", _on_request_show_context_menu)
	node.connect("skill_node_clicked", _on_skill_node_clicked)
	node.set_drag_forwarding(Callable(), _can_drop_data, _drop_data)
	skill_node_by_id[node.resource.skill_id] = node.resource
	skill_node_scene_by_id[node.resource.skill_id] = node
	add_child(node)


func _on_request_show_context_menu(node: Control):
	print('on_context')
	var menu = edit_context_menu.instantiate()
	add_child(menu)
	menu.set_label(str('Node #', node.resource.skill_id))
	menu.global_position = get_global_mouse_position() + Vector2(20, 20)
	print('added menu for ', node)
	var button_type = await menu.button_pressed
	_on_context_button_pressed(button_type, node)


func _on_skill_node_clicked(node: Control):
	if is_linking and link_origin_node:
		if link_origin_node != node:
			print('linking ', link_origin_node.resource.skill_id, ' with ', node.resource.skill_id)
			link_origin_node.add_link(node.resource.skill_id)
			node.add_link(link_origin_node.resource.skill_id)
			queue_redraw()
		is_linking = false
		link_origin_node = null

func _on_context_button_pressed(button_type, node: Control):
	print('button pressed', button_type)
	match button_type:
		"Edit":
			return
		"Link":
			is_linking = true
			link_origin_node = node
		"Delete":
			print('deleting', node)
			remove_links(node)
			resource.nodes.erase(node.resource)
			skill_node_by_id.erase(node.resource.skill_id)
			skill_node_scene_by_id.erase(node.resource.skill_id)
			remove_child(node)
			node.queue_free()


func remove_links(node: Control):
	var target: SkillNodeResource
	var origin_id = node.resource.skill_id
	for link in node.resource.links:
		target = skill_node_by_id[link]
		target.links.erase(origin_id)
	node.resource.links.clear()


func _can_drop_data(at_position, data):
	return true


func _drop_data(at_position: Vector2, node):
	if node is Control:
		node.set_node_position((at_position + Vector2(-8,-8)).snapped(get_snap_pixels()))
		queue_redraw()
