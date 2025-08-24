class_name SkillNodeResource
extends Resource

@export var skill_id: int = -1
@export var position: Vector2 
@export var links: Array[int]
@export var name: StringName
@export var scale: Vector2 = Vector2(1,1)
@export_color_no_alpha var fill_color
@export_color_no_alpha var border_color
@export var background_texture: Texture2D
@export var foreground_texture: Texture2D
@export var allocation_bonuses: Array[StatBonusResource]
