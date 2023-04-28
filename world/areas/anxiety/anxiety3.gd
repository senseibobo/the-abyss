extends Node2D

var timer: float = 7.0
onready var red = $CanvasLayer/ColorRect
func _process(delta: float) -> void:
	timer += delta
	if timer >= 8.0:
		timer -= 8.0
		Global.player.shockwaved()
		Global.camera.shake(15.0,2.5,2.0)
		red.color.a = 0.3
		var tween = create_tween()
		tween.tween_property(red,"color:a",0.0,0.5)

func finished():
	$AnxietyParticles.emitting = false
	var vignette = $WorldEnvironment/ScreenShader/vignette
	var tween = create_tween()
	tween.tween_property(vignette.material,"shader_param/minimum",1.0,2.0)
	timer = -1000000000.0
	yield(get_tree().create_timer(3.0),"timeout")
	red.color = Color(1.0,1.0,1.0,0.0)
	tween = create_tween()
	tween.tween_property(red,"color",Color.white,2.0)
	tween.tween_callback(Transition,"change_scene",["res://world/areas/lobby/lobby.tscn"])
