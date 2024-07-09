extends CanvasLayer

signal restart

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			restart.emit()
		else:
			pass
