extends Node2D


@export var resource: SkillNodeResource


func set_resource(res: SkillNodeResource):
	print('set_resource ', res.position)
	resource = res
	global_position = res.position
	if res.background_texture:
		$background.texture = res.background_texture
	if res.foreground_texture:
		$foreground.texture = res.foreground_texture
	scale = res.scale


func set_node_position(pos: Vector2):
	resource.position = pos
	global_position = pos


func create_new_resource(next_id: int, links: Array[int] = []):
	assert(next_id, 'SkillBoardNode requires a skill_id to be passed as next_id, but received none')
	resource = SkillNodeResource.new()
	resource.skill_id = next_id
	resource.links = links


