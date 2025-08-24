@tool
extends Area2D

@export_enum("door1", "door2", "door3", "bomb", "boots", "creaturePhasing", "coin", "heart", "heartPiece") var kind: String = "coin"

func _ready() -> void:
	setup_sprite()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		setup_sprite()

func setup_sprite():
	$Sprite2D.modulate = Color.WHITE
	$Sprite2D.scale = Vector2(1.5, 1.5)
	match kind:
		"door1":
			$Sprite2D.frame = 73
			$Sprite2D.modulate = Color.RED
		"door2":
			$Sprite2D.frame = 73
			$Sprite2D.modulate = Color.ROYAL_BLUE
		"door3":
			$Sprite2D.frame = 73
			$Sprite2D.modulate = Color.WEB_GREEN
		"bomb":
			$Sprite2D.frame = 123
		"boots":
			$Sprite2D.frame = 346
		"creaturePhasing":
			$Sprite2D.frame = 290
		"heart":
			$Sprite2D.frame = 115
			$Sprite2D.scale = Vector2(1,1)
		"heartPiece":
			$Sprite2D.frame = 116
		"coin":
			$Sprite2D.frame = 103


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		match kind:
			"coin":
				Global.coins += 5
		if Global.unlocks.has(kind) and Global.unlocks[kind] == false:
			Global.unlocks[kind] = true
			print("unlocked ", kind)
			SignalBus.emit_signal("unlock_granted", kind)
		SignalBus.emit_signal("pickup_collected", kind)
		queue_free()
