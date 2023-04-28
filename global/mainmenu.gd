extends Control



func _on_Play_pressed() -> void:
	Transition.change_scene("res://world/areas/tutorial/tutorialarea.tscn",0.3)
