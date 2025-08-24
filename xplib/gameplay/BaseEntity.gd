class_name BaseEntity
extends Node

# (inventory[])
#signal inventory_updated
signal inventory_item_added(item)
signal inventory_item_removed(item)
signal inventory_item_stacks_changed(new_stacks, old_stacks, item)

var gid = -1
var tags = []
var tag_map = {}
var inventory = []

func _ready() -> void:
	for tag in tags:
		tag_map[tag] = true

func add_to_inventory(item: Item):
	inventory.push_back(item)
	item.connect("stacks_changed", Callable(self, "_inventory_item_stacks_changed").bind(item))
	item.connect("destroyed", Callable(self, "_inventory_item_destroyed").bind(item))
	emit_signal("inventory_item_added", item)

func remove_from_inventory(item: Item):
	inventory.erase(item)
	item.disconnect("stacks_changed", Callable(self, "_inventory_item_stacks_changed"))
	item.disconnect("destroyed", Callable(self, "_inventory_item_destroyed"))
	emit_signal("inventory_item_removed", item)

func _inventory_item_stacks_changed(new_stacks: int, old_stacks: int, item: Item):
	emit_signal("inventory_item_stacks_changed", new_stacks, old_stacks, item)

func _inventory_item_destroyed(item: Item):
	emit_signal("inventory_item_removed", item)
