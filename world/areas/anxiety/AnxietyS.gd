extends Area2D

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	$CollisionShape2D.position.y = sin(time)*20.0



func _on_AnxietyS_body_entered(body: Node) -> void:
	set_deferred("monitoring",false)
	$CollisionShape2D/Sprite.visible = false
	$CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D/Particles2D.emitting = true
	Global.camera.shake(10.0,1.5,1.0)
