@tool
extends Node2D

@export var frame_width: int = 24
@export var frame_height: int = 24
@export var spritesheet_texture: Texture2D

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Sprite2D.texture = spritesheet_texture
		if !frame_width or !frame_height or !spritesheet_texture:
			return
		
		var sprite_width = $Sprite2D.texture.get_width()
		var sprite_height = $Sprite2D.texture.get_height()
		$Sprite2D.global_position = Vector2(sprite_width / 2, sprite_height / 2)
		
		var hframes = sprite_width / frame_width
		var vframes = sprite_height / frame_height
		
		var mouse_pos = get_viewport().get_mouse_position()
		var mouse_frame_x = ceil(mouse_pos.x / frame_width)
		var mouse_frame_y = ceil(mouse_pos.y / frame_height)
		var frame_max = sprite_width / frame_width * sprite_height / frame_height - 1
		var frame_index = clamp((mouse_frame_y - 1) * hframes + mouse_frame_x - 1, 0, frame_max)
		
		$SpritePreview.texture = $Sprite2D.texture
		var preview_width = $SpritePreview.texture.get_width()
		var preview_height = $SpritePreview.texture.get_height()
		$SpritePreview.hframes = preview_width / frame_width
		$SpritePreview.vframes = preview_height / frame_height
		$SpritePreview.frame = frame_index
		
		$SpritePreview.global_position = Vector2(-frame_width * $SpritePreview.scale.x, 100 + frame_height * $SpritePreview.scale.y)
		
		$Label.text = "Frame pos: %d,%d\nFrame index: %d" % [mouse_frame_x, mouse_frame_y, frame_index]
