class_name Player
extends CharacterBody2D

@export var camera: Camera2D
var anim_frames = [63,83]
var anim_acc = 0.1
var movement_locked: float = 0
var last_moving_dir: Vector2
var room_starting_pos: Vector2
var bomb_proj_scene = preload("res://src/gameplay/bomb_proj.tscn")

func _ready() -> void:
	camera.connect("room_changed", _on_room_changed)

func _process(delta: float) -> void:
	var speed = 200
	movement_locked -= delta
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_dir.normalized()
	anim_acc -= delta

	if anim_acc <= 0:
		anim_acc = 0.15
		if $Sprite2D.frame == anim_frames[0]:
			$Sprite2D.frame = anim_frames[1]
		else:
			$Sprite2D.frame = anim_frames[0]

	if movement_locked <= 0:
		if input_dir.length_squared() > 0:
			last_moving_dir = input_dir
		velocity = speed * input_dir
		move_and_slide()
		$Sprite2D.flip_h = sign(input_dir.x) == 1

	if Input.is_action_just_pressed("action_primary"):
		print('boots!')

	if Input.is_action_just_pressed("action_2"):
		if Global.unlocks["bomb"] == true:
			var proj = bomb_proj_scene.instantiate()
			proj.initial_dir = last_moving_dir
			proj.global_position = global_position
			get_parent().add_child(proj)
			print('created bomb')

	if Input.is_action_just_pressed("action_3"):
		global_position = room_starting_pos
	


func _on_room_changed(room_x, room_y):
	prints('room changed', room_x, ',', room_y)
	room_starting_pos = global_position
