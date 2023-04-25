extends Node2D

onready var cr = $ColorRect

func _process(delta: float) -> void:
	cr.material.set_shader_param("camera_position",Global.camera.global_position)
