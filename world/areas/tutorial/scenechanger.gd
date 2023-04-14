extends Area2D

export(String, FILE) var scene_path 

func player_entered(body) -> void:
	get_tree().change_scene(scene_path)
