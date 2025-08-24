extends CharacterBody2D

var initial_dir: Vector2

func _process(delta: float) -> void:
	rotation += delta * 5
	var speed = 200
	velocity = speed * initial_dir
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	prints('body', body)
	if body is BombTile:
		body.destroy()
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	prints('area', area)
