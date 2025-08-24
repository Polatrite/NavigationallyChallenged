extends Node2D

@onready var sprite_order_left_to_right = [$Sprite1, $Sprite2, $Sprite3, $Sprite4, $Sprite5, $Sprite6, $Sprite7]
@onready var sprite_order_middle_out = [$Sprite4, $Sprite3, $Sprite5, $Sprite2, $Sprite6, $Sprite1, $Sprite7] # prefers left side node
var sprite_order = []
var orb_empty = preload("res://gameplaylib-assets/ability-orbs/orb-0.png")
var orb_cold = preload("res://gameplaylib-assets/ability-orbs/orb-1.png")
var orb_fire = preload("res://gameplaylib-assets/ability-orbs/orb-2.png")
var orb_nature = preload("res://gameplaylib-assets/ability-orbs/orb-3.png")
var orb_poison = preload("res://gameplaylib-assets/ability-orbs/orb-4.png")
var orb_form = preload("res://gameplaylib-assets/ability-orbs/orb-5.png")
var orb_supernatural = preload("res://gameplaylib-assets/ability-orbs/orb-6.png")
var orb_light = preload("res://gameplaylib-assets/ability-orbs/orb-7.png")

func set_orb_bar_length(length: int):
	var count = 1
	for sprite in get_children():
		if count <= length:
			sprite.visible = true
		else:
			sprite.visible = false
		count += 1
	var order_offset = floor((7 - length) / 2)
	sprite_order = sprite_order_left_to_right.slice(order_offset, length)

func update_sprites(current_orbs: Array):
	var sprites = get_children()
	current_orbs.sort()
	for i in sprite_order.size():
		var sprite: Sprite2D = sprite_order[i]
		if current_orbs.size() > i:
			var orb_type = current_orbs[i]
			match orb_type:
				Enum.DamageType.Cold:
					sprite.texture = orb_cold
				Enum.DamageType.Fire:
					sprite.texture = orb_fire
				Enum.DamageType.Nature:
					sprite.texture = orb_nature
				Enum.DamageType.Form:
					sprite.texture = orb_form
				Enum.DamageType.Supernatural:
					sprite.texture = orb_supernatural
				Enum.DamageType.Light3D:
					sprite.texture = orb_light
		else:
			sprite.texture = orb_empty

func _on_orbs_changed(current_orbs, orbs_added, orbs_removed):
#	print("_on_orbs_changed", current_orbs)
	update_sprites(current_orbs)
	#TODO JUICE: animate orbs appearing/disappearing

