class_name Player
extends CharacterBody2D

@export var camera: Camera2D
var anim_frames = [63,83]
var anim_acc = 0.1
var movement_locked: float = 0
var last_moving_dir: Vector2
var room_starting_pos: Vector2
var bomb_proj_scene = preload("res://src/gameplay/bomb_proj.tscn")
var shadow_frames = [462, 461]
var is_jumping = false
var is_autojumping = false
var jump_acc: float = 0.0
var jump_tween: Tween

func _ready() -> void:
	camera.connect("room_changed", _on_room_changed)

func _process(delta: float) -> void:
	var speed = 200
	movement_locked -= delta
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_dir.normalized()
	anim_acc -= delta
	jump_acc -= delta
	if jump_acc <= 0:
		is_jumping = false

	set_collision_layer_value(2, !is_jumping)
	print('collmask', collision_mask)

	if anim_acc <= 0:
		anim_acc = 0.15
		if $Sprite2D.frame == anim_frames[0]:
			$Sprite2D.frame = anim_frames[1]
		else:
			$Sprite2D.frame = anim_frames[0]

	if is_autojumping:
		input_dir = last_moving_dir
		velocity = 160 * input_dir
		move_and_slide()

	if movement_locked <= 0 and !is_autojumping:
		if input_dir.length_squared() > 0:
			last_moving_dir = input_dir
		velocity = speed * input_dir
		move_and_slide()
		$Sprite2D.flip_h = sign(input_dir.x) == 1

	if is_autojumping or Input.is_action_just_pressed("action_primary"):
		if !is_jumping:
			print('boots!')
			is_jumping = true
			is_autojumping = true
			jump_acc = 0.3
			$Shadow.visible = true
			$Shadow.frame = shadow_frames[0]
			var tween = get_tree().create_tween()
			jump_tween = tween
			tween.tween_property($Sprite2D, "position", Vector2(0,-24), jump_acc/2)
			tween.chain()
			tween.tween_property($Sprite2D, "position", Vector2(0, 0), jump_acc/2)
			tween.play()

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

func stop_jumping():
	if jump_tween:
		jump_tween.stop()
	$Sprite2D.position.y = 0
	is_autojumping = false
	is_jumping = false
	jump_acc = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	prints('body', body)
	if body is TileMapLayer or body is BombTile:
		stop_jumping()

func fall_in_pit():
	stop_jumping()
	global_position = room_starting_pos
