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
