extends Node2D

var dir: int = 1
var x
var y
var timer: float
var count: int = 0

func _ready() -> void:
	x = global_position.x
	y = global_position.y
var yields_started = 0
func _process(delta: float) -> void:
	timer += delta
	var remove = false
	if count > 150: 
		if yields_started == 0: queue_free()
		return
	while timer >= 0.02:
		timer -= 0.02
		var part = preload("res://characters/boss/shockwave1/part.tscn").instance()
		add_child(part)
		part.global_position.x = x
		part.global_position.y = y
		x += 12*dir
		yields_started += 1
		yield(Global.timer(0.05),"timeout")
		yields_started -= 1
		count += 1
