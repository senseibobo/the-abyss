extends Node2D

var timer: float = 10.0
func _process(delta: float) -> void:
	timer += delta
	if timer >= 11.0:
		timer -= 11.0
		var shockwave = preload("res://world/areas/anxiety/shockwave.tscn").instance()
		add_child(shockwave)
		shockwave.start_shockwave()
