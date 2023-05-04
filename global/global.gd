extends Node

var player
var will
var enemies: Array
var camera
var fog

func show_ui(visible: bool = true):
	Global.player.ui.visible = visible

func _ready() -> void:
	randomize()

func timer(time: float):
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",timer,"queue_free")
	timer.start(time)
	return timer
