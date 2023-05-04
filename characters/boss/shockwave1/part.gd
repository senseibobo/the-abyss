extends Node2D

var time: float = 0.0

func _ready() -> void:
	$Area2D.scale.y = 0

func _process(delta: float) -> void:
	$Area2D.scale.y = sin(time)*0.6
	time += 10.0*delta
	if time >= PI:
		queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	body.hit()
