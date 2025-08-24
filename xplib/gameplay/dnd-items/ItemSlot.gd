extends TextureRect

signal slot_data_changed(item_id, item_data, persist_data)
@export var requirelist: Array = [] # (Array, Enum.ItemSlotCategory)
@export var blacklist: Array = [] # (Array, Enum.ItemSlotCategory)

var item_id = 0
var item_data
var persist_data
var _drag_texture

func set_lists(required, black = []):
	requirelist = required
	blacklist = black

func clear_slot_data():
	print('clear_slot_data()', self)
	item_id = null
	item_data = null
	persist_data = null
	update_textures()
	emit_signal("slot_data_changed", item_id, item_data, persist_data)

func set_slot_data(_item_id: int, _persist_data = null):
	item_id = _item_id
	item_data = ItemDataLoader.item_data[str(item_id)]
	prints('set_slot_data()', _item_id, item_data)
	persist_data = _persist_data
	update_textures()
	emit_signal("slot_data_changed", item_id, item_data, persist_data)

func can_item_drop(new_item_id: int):
	var item_data = ItemDataLoader.item_data[str(new_item_id)]
#	print('  CAT SCAN')
	var valid_cats = 0
	var valid = true
	for category in item_data["SlotCategory"]:
#		prints('  ', item_data["Name"], category)
		if category in requirelist:
#			prints('    category', category, ' in requirelist', requirelist)
			valid_cats += 1
		if category in blacklist:
#			prints('    category', category, ' in blacklist', blacklist)
			valid = false
	return valid and valid_cats >= requirelist.size()

func _get_drag_data(position: Vector2):
	if !item_id:
		return false
	var data = {
		"origin_node": self,
		"origin_item_id": item_id,
		"origin_persist_data": persist_data,
	}
	prints('_get_drag_data()', data, _drag_texture)
	var _drag_control = Control.new()
	_drag_control.add_child(_drag_texture.duplicate())
	set_drag_preview(_drag_control)
	return data

func _can_drop_data(position: Vector2, data) -> bool:
	if !data or !data.origin_item_id or data.origin_node == self:
		return false
	var this_to_origin_result = true
	if item_id:
		prints('\t\t has item_id', item_id)
		this_to_origin_result = data.origin_node.can_item_drop(item_id)
		if this_to_origin_result:
			data['swapped_node'] = self
			data['swapped_item_id'] = item_id
			data['swapped_persist_data'] = persist_data
	else:
		prints('\t\t else')
		data['swapped_node'] = null
		data['swapped_item_id'] = null
		data['swapped_persist_data'] = null
	var origin_to_this_result = can_item_drop(data.origin_item_id)
#	prints('can_drop_data() ', origin_to_this_result, this_to_origin_result)
	return origin_to_this_result and this_to_origin_result


func _drop_data(position: Vector2, data) -> void:
	prints('_drop_data()', position, data)
	if data.has("swapped_node") and data["swapped_node"]:
#		print('  swappin', data)
		data.origin_node.set_slot_data(data.swapped_item_id, data.swapped_persist_data)
	else:
		data.origin_node.clear_slot_data()
	set_slot_data(data.origin_item_id, data.origin_persist_data)

func update_textures():
	if item_data:
		var name = item_data["Name"]
		if item_data.has("Icon"):
			print('\tupdating texture to icon')
			!!null
#			update_texture_from_icon()
		elif item_data.has("IconSheet"):
			print('\tupdating texture to iconsheet')
			update_texture_from_icon_sheet()
		$Label.text = name
	else:
		$Label.text = ""
		clear_texture()

func update_texture_from_icon():
	# clear SheetDark
	$SheetDark.texture = null
	
	# setup Icon
	var icon_name = item_data["Icon"]
	var icon_texture = load(str("res://assets/unity/items/", icon_name, ".png"))
	$Icon.set_texture(icon_texture)
	
	# configure the drag texture
	_drag_texture = TextureRect.new()
	_drag_texture.expand = true
	_drag_texture.texture = icon_texture
	_drag_texture.size = $Icon.size
	_drag_texture.scale = $Icon.scale
	_drag_texture.position = -0.5 * _drag_texture.size * _drag_texture.scale

func update_texture_from_icon_sheet():
	# clear Icon
	$Icon.texture = null
	
	# setup SheetDark
	var icon_sheet = item_data["IconSheet"]
	var icon_frame = item_data["IconFrame"]
#	var icon_texture = load(str("res://assets/creatures/", icon_sheet, ".png"))
#	$SheetDark.texture = icon_texture
#	if icon_sheet == "creature":
#		$SheetDark.hframes = 8
#		$SheetDark.vframes = 3
	$SheetDark.frame = icon_frame
	$SheetLight.frame = icon_frame
	print('\tsetting frame to ', icon_frame)

	# configure the drag texture
	_drag_texture = Sprite2D.new()
	_drag_texture.texture = $SheetLight.texture
	_drag_texture.hframes = $SheetDark.hframes
	_drag_texture.vframes = $SheetDark.vframes
	_drag_texture.frame = icon_frame
	_drag_texture.scale = Vector2(2,2)


func clear_texture():
	$Icon.texture = null
	$SheetDark.frame = 0
	$SheetLight.frame = 0
