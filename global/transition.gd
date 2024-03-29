extends Node

signal transitioned
signal finished_transition
signal continue_transition

onready var trans_rect = $CanvasLayer/ColorRect

func start_transition(pause: bool = true,speed_multiplier: float = 1.0):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(trans_rect.material,"shader_param/progress",0.5,0.5/speed_multiplier)
	trans_rect.material.set_shader_param("progress",0.0);
	tween.tween_callback(self,"emit_signal",["transitioned"])
	if pause:
		yield(self,"continue_transition")
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(trans_rect.material,"shader_param/progress",1.0,0.5/speed_multiplier)
	tween.tween_callback(self,"emit_signal",["finished_transition"])


func continue_trans():
	emit_signal("continue_transition")

func restart_scene():
	change_scene(get_tree().current_scene.filename)

func change_scene(scene_path: String,speed_multiplier: float = 1.0):
	print(scene_path)
	start_transition(true,speed_multiplier)
	yield(self,"transitioned")
	get_tree().change_scene(scene_path)
	emit_signal("continue_transition")
