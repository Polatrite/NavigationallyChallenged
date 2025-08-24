class_name Item
extends Node

signal location_changed(new_location, old_location)
signal stacks_changed(new_stacks, old_stacks)
signal destroyed()

var item_type: int
var template
var item_name: String
var icon: String
var slot_categories: Array = []
var stacks: int = 1
var tags = []
var tag_map = {}
var location
var is_consumable: bool: get = _is_consumable
var is_equippable: bool: get = _is_equippable
var is_stackable: bool: get = _is_stackable



func _ready() -> void:
	for tag in tags:
		tag_map[tag] = true


func _is_consumable() -> bool:
	return tag_map.get("consumable")
func _is_equippable() -> bool:
	return tag_map.get("equippable")
func _is_stackable() -> bool:
	return tag_map.get("stackable")


func move(target, stacks_to_move: int = -1):
	if stacks_to_move == -1:
		stacks_to_move = stacks 
	if target["inventory"] != null: # entities and other inventory things
		if _is_stackable():
			# if the target has an existing item, we'll just move some stacks from this item to their existing item
			for item in target.inventory:
				if item.item_type == item_type:
					item._move_stacks_from_item(self, stacks_to_move)
					return
			# otherwise if we can't move this entire item to the target, we'll have to duplicate this and put the partial stacks into their inventory
			if stacks_to_move < stacks:
				var newly_created_item: Item = _clone_set_stacks(stacks_to_move)
				newly_created_item.location = null
				newly_created_item._change_location(target)
				remove_stacks(stacks_to_move)
				return
		# otherwise we'll just move this entire item to the target
		_change_location(target)
	elif target["global_position"] != null:
		var x = target.global_position
		var y = target.global_position
		print('moving to terrain not implemented')


static func get_item_by_type(item_type: int, target) -> Item:
	for item in target.inventory:
		if item.item_type == item_type:
			return item
	return null


static func get_items_by_type(item_type: int, target) -> Item:
	var items = []
	for item in target.inventory:
		if item.item_type == item_type:
			items.push_back(item)
	return items


func _clone_set_stacks(new_stacks: int) -> Item:
	var new_item: Item = duplicate()
	new_item.item_type = item_type
	for tag in tags:
		new_item.add_tag(tag)
	new_item.stacks = new_stacks
	return new_item


func _change_location(new_location):
	var old_location = location
	if old_location:
		old_location.remove_from_inventory(self)
	new_location.add_to_inventory(self)
	location = new_location
	emit_signal("location_changed", new_location, old_location)


func destroy():
	emit_signal("destroyed")
	queue_free()


func add_tag(tag: String):
	if tags.find(tag) == -1:
		tags.push_back(tag)
	tag_map[tag] = true

func remove_tag(tag: String):
	tags.erase(tag)
	tag_map[tag] = null

func add_stacks(stacks_to_add: int):
	var old_stacks = stacks
	stacks += stacks_to_add
	emit_signal("stacks_changed", stacks, old_stacks)

func _move_stacks_from_item(new_item: Item, stacks_to_add: int):
	add_stacks(stacks_to_add)
	new_item.remove_stacks(stacks_to_add)

func remove_stacks(stacks_to_remove: int):
	var old_stacks = stacks
	stacks -= stacks_to_remove
	if stacks <= 0:
		assert(stacks == 0, str("Tried to remove more stacks from item than existed, item_type: ", item_type))
		destroy()
	else:
		emit_signal("stacks_changed", stacks, old_stacks)


