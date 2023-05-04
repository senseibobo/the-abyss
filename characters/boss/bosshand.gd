extends KinematicBody2D

var start_position: Vector2

var bp: Vector2

func _ready() -> void:
	start_position = global_position
	bp = get_parent().global_position

func hit():
	var tween = create_tween()
	$Hand.modulate = Color.white
	tween.tween_property($Hand,"modulate",Color.red,0.3)
	get_parent().hit(20)

func back():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"global_position",start_position,0.5)
	yield(tween,"finished")
	return

func slam1():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"global_position",global_position + Vector2.UP*150.0,0.8)
	tween.tween_interval(0.5)
	yield(tween,"finished")
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"global_position",global_position + Vector2.DOWN*150.0,0.25)
	tween.tween_callback(self,"send_shockwaves1")
	yield(tween,"finished")
	return

func send_shockwaves1():
	for i in 2:
		var shockwave = preload("res://characters/boss/shockwave1/shockwave1.tscn").instance()
		shockwave.dir = (i*2)-1
		shockwave.global_position = global_position + Vector2(0,50)
		$"../..".add_child(shockwave)

func clap(dir):
	Global.camera.shake(60.0,0.1,3.0)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"global_position",Vector2(bp.x+dir*300,bp.y+100),0.6)
	yield(tween,"finished")
	yield(Global.timer(0.15),"timeout")
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"global_position",Vector2(bp.x+dir*40,bp.y+100),0.3)
	yield(tween,"finished")
	Global.camera.shake(30.0,2.5,1.0)
	return

func align_to_wall():
	var dir = 1 if global_position.x > 0 else -1
	Global.camera.shake(60.0,0.1,3.0)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"global_position",Vector2(bp.x+dir*100,bp.y+70),0.4)
	yield(Global.timer(0.15),"timeout")
	yield(tween,"finished")

func hit_wall():
	#Engine.time_scale = 0.2
	var dir = 1 if global_position.x > 0 else -1
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"global_position",Vector2(bp.x+dir*300,bp.y+70),0.3)
	yield(tween,"finished")
	align_to_wall()
	var x = global_position.x + dir*50
	var missing = randi()%2 + 2
	for i in 4:
		if i == missing: continue
		var y = global_position.y + i*52
		launch_ball(Vector2(x,y),-dir)
	Global.camera.shake(30.0,2.5,1.0)
	return
	
func launch_ball(pos,dir):
	var velocity = Vector2(dir*50,0)
	var ball = preload("res://characters/boss/ball/ball.tscn").instance()
	ball.velocity = velocity
	get_parent().add_child(ball)
	ball.global_position = pos
