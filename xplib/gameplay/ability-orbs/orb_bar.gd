extends Node2D

@onready var sprite_order_left_to_right = [$Sprite1, $Sprite2, $Sprite3, $Sprite4, $Sprite5, $Sprite6, $Sprite7]
@onready var sprite_order_middle_out = [$Sprite4, $Sprite3, $Sprite5, $Sprite2, $Sprite6, $Sprite1, $Sprite7] # prefers left side node
var sprite_order = []
var orb_empty = 15
var orb_cold = 10
var orb_fire = 4
var orb_nature = 6
var orb_poison = 6
var orb_form = 2
var orb_supernatural = 11
var orb_light = 7


func set_orb_bar_length(length: int):
	var count = 1
	for sprite in get_children():
		if count <= length:
			sprite.visible = true
		else:
			sprite.visible = false
		count += 1
	var order_offset = floor((7 - length) / 2)
#	sprite_order = sprite_order_middle_out.slice(order_offset, length+1)
	sprite_order = sprite_order_left_to_right.slice(order_offset, length+1)
	pass


func update_sprites(current_orbs: Array):
	var sprites = get_children()
	current_orbs.sort()
	for i in sprite_order.size():
		var sprite: Sprite2D = sprite_order[i]
		if current_orbs.size() > i:
			var orb_type = current_orbs[i]
#			prints('orb_type', orb_type)
			match orb_type:
				Enum.DamageType.Cold:
					sprite.frame = orb_cold
				Enum.DamageType.Fire:
					sprite.frame = orb_fire
				Enum.DamageType.Nature:
					sprite.frame = orb_nature
				Enum.DamageType.Form:
					sprite.frame = orb_form
				Enum.DamageType.Supernatural:
					sprite.frame = orb_supernatural
				Enum.DamageType.Light:
					sprite.frame = orb_light
		else:
			sprite.frame = orb_empty
#			prints('orb_type empty')

func _on_orbs_changed(current_orbs, orbs_added, orbs_removed):
#	print("orb_bar._on_orbs_changed", current_orbs)
	update_sprites(current_orbs)
	#TODO JUICE: animate orbs appearing/disappearing

