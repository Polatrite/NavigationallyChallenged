@tool
extends GridContainer

@export var requiredlist: Array = [] # (Array, Enum.ItemSlotCategory)
@export var blacklist: Array = [] # (Array, Enum.ItemSlotCategory)
@export var contents: Dictionary = {}
@export var cell_width: int = 5
@export var cell_height: int = 5
var item_slot_template = preload("res://xplib/gameplay/dnd-items/ItemSlot.tscn")


func _ready() -> void:
	columns = cell_width
	init_slots()
	set_lists(requiredlist, blacklist)


func init_slots():
	for i in range(cell_width * cell_height):
		var new_slot = item_slot_template.instantiate()
		add_child(new_slot)
	set_lists()
	update_items()


func set_contents(cont: Dictionary):
	contents = cont
	prints('set_contents', contents)
	set_lists()
	update_items()

func update_items():
	var children = get_children()
	var index = 0
	for i in contents.keys():
		var slot = children[index]
		index += 1
		var item_id = contents[i]["Item"]
		print('updating item: ', slot, item_id)
		if item_id != null:
			slot.set_slot_data(item_id)
			slot.can_item_drop(item_id)

func set_lists(required = null, black = null):
	if required:
		requiredlist = required
	if black:
		blacklist = black
	set_lists_on_all_child_nodes(self)

func set_lists_on_all_child_nodes(node):
	for child in node.get_children():
		if child.has_method("set_lists"):
			child.set_lists(requiredlist, blacklist)
		if child.get_child_count() > 0:
			print('RECURSING')
			set_lists_on_all_child_nodes(child)
