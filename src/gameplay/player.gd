class_name Player
extends CharacterBody2D

@export var camera: Camera2D
var anim_frames = [63,83]
var anim_acc = 0.1
var movement_locked: float = 0

func _ready() -> void:
	camera.connect("room_changed", _on_room_changed)

func _process(delta: float) -> void:
	movement_locked -= delta
	anim_acc -= delta
	
	if anim_acc <= 0:
		anim_acc = 0.15
		if $Sprite2D.frame == anim_frames[0]:
			$Sprite2D.frame = anim_frames[1]
		else:
			$Sprite2D.frame = anim_frames[0]

	if movement_locked <= 0:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var speed = 200
		input_dir.normalized()
		velocity = speed * input_dir
		move_and_slide()
		$Sprite2D.flip_h = sign(input_dir.x) == 1


func _on_room_changed(room_x, room_y):
	prints('room changed', room_x, ',', room_y)
