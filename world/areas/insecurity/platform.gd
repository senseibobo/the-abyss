extends GSC



func _on_Area2D_body_entered(body: Node) -> void:
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",0.0,0.4)
	tween.tween_callback($CollisionShape2D,"set_deferred",["disabled",true])
	tween.tween_interval(2.0)
	tween.tween_callback($CollisionShape2D,"set_deferred",["disabled",false])
	tween.tween_property(self,"modulate:a",1.0,0.1)
