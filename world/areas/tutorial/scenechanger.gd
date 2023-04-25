extends Area2D

export(String, FILE) var scene_path 

func player_entered(body) -> void:
	Transition.change_scene(scene_path)
