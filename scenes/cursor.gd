extends Node

var cursor = load("res://assets/cursor.png")
var cursorTick = load("res://assets/cursorTick.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.set_custom_mouse_cursor(cursorTick)
		else:
			_ready()
