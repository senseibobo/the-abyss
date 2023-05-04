extends Node2D

var dir = randi()%2
var velocity: float = 50

func _ready() -> void:
	$Sprite.frame = randi()%4

func _process(delta):
	global_position.y += velocity*delta
	velocity += delta*350.0
	$Sprite.rotation += dir*delta*2.0
	if global_position.y > 1200:
		queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	body.hit()
