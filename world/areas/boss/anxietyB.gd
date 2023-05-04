extends Node2D


onready var red = $CanvasLayer/ColorRect

func _on_Boss_dead() -> void:
	$AnxietyParticles.emitting = false
	var vignette = $WorldEnvironment/ScreenShader/vignette
	var tween = create_tween()
	tween.tween_property(vignette.material,"shader_param/minimum",1.0,2.0)
	yield(get_tree().create_timer(3.0),"timeout")
	red.color = Color(1.0,1.0,1.0,0.0)
	tween = create_tween()
	tween.tween_property(red,"color",Color.white,2.0)
	tween.tween_callback(Transition,"change_scene",["res://world/areas/lobby/lobby.tscn"])
