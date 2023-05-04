extends StaticBody2D

func hit():
	var tween = create_tween()
	$ColorRect2.color = Color(0.77,0.6,0.6,1.0)
	tween.tween_property($ColorRect2,"color",Color(0.77,0,0,1),0.1)
	$"../..".hit(10.0)
