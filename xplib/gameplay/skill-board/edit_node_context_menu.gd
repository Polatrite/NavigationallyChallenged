extends PanelContainer


signal button_pressed(button_type)
@onready var label = $buttons/label


func _ready():
	for child in $buttons.get_children():
		child.connect("pressed", _on_button_pressed.bind(child.text))


func _on_button_pressed(button_text: String):
	emit_signal("button_pressed", button_text)
	queue_free()


func set_label(msg: String):
	label.text = msg
