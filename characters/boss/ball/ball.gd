extends Node2D

var velocity: Vector2

func _physics_process(delta: float) -> void:
	global_position += velocity*delta
	velocity += velocity.normalized()*250.0*delta
	$Sprite.rotation = Vector2().angle_to_point(velocity)


func _on_Area2D_body_entered(body: Node) -> void:
	body.hit()
