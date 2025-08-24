extends CharacterBody2D


@export_group("Graphics")
## This config object contains ALL the below properties, and will auto-configure the character based on this information.
@export var graphics_config: Resource

@export var has_graphics_shadow: bool = false

@export_subgroup("Animation")
@export var has_anim_idle: bool = true
@export var anim_idle_frames: int = 12
@export var has_anim_idle_start: bool = true
@export var anim_idle_start_frames: int = 12
@export var has_anim_idle_end: bool = true
@export var anim_idle_end_frames: int = 12

@export var has_anim_attack: bool = true
@export var anim_attack_frames: int = 6

@export var has_anim_die: bool = true
@export var anim_die_frames: int = 20

@export var has_anim_damaged: bool = true
@export var anim_damaged_frames: int = 4

@export var has_anim_jump: bool = true
@export var anim_jump_frames: int = 4

@export var has_anim_walk: bool = true
@export var anim_walk_frames: int = 4
