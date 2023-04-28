extends CanvasLayer

onready var cr = $ColorRect

func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	cr.material.set_shader_param("camera_position",Global.camera.global_position)
	var pp = (Global.player.global_position-Global.camera.global_position)/get_viewport().get_size()
	cr.material.set_shader_param("pc_position",pp+Vector2(0.5,0.5))
