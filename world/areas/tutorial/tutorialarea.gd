extends Node2D

func _ready() -> void:
	Global.show_ui(false)
	
func show_ui():
	Global.show_ui(true)
