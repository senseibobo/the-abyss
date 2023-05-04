extends CanvasLayer

func _process(delta: float) -> void:
	var minimum = -0.000125*Global.player.global_position.y
	$vignette.material.set_shader_param("minimum",minimum)
