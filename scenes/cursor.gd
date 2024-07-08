extends Node

var arrow = load("res://assets/cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(arrow)
