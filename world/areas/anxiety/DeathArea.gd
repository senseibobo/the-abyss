extends Area2D



func _on_DeathArea_body_entered(body: Node) -> void:
	body.death()
