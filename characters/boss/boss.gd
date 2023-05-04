extends Enemy

signal dead

const attack_count = 3

onready var left = $LeftHand
onready var right = $RightHand

func _ready() -> void:
	$CanvasLayer/Healthbar.max_value = max_health
	$CanvasLayer/Healthbar.value = health
	attacking()

func _process(delta: float) -> void:
	$LArm.points = [$LShoulder.global_position,$LeftHand.global_position]
	$RArm.points = [$RShoulder.global_position,$RightHand.global_position]

func attacking():
	while true:
		if health <= 0: 
			death()
			break
		yield(get_tree().create_timer(0.5,false),"timeout")
		var attack = randi()%attack_count
		yield(call("attack"+str(attack+1)),"completed")
			
func hit(amount: float = 20.0):
	health -= amount
	$CanvasLayer/Healthbar.value = health

func death():
	left.back()
	yield(right.back(),"completed")
	Global.camera.shake(10,2,5)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(left,"position",Vector2(-200,-120),0.6)
	tween.tween_property(right,"position",Vector2(200,-120),0.6)
	tween.chain().tween_interval(2.0)
	tween.tween_property(self,"modulate",Color(1,1,1,0),2.0)
	emit_signal("dead")
	
	
func attack1():
	left.back()
	yield(right.back(),"completed")
	Global.camera.shake(60.0,0.1,3.0)
	var r = randi()%2
	var first
	var second
	if r == 0:
		first = left
		second = right
	elif r == 1:
		first = right
		second = left
	first.slam1()
	yield(second.slam1(),"completed")
	Global.camera.shake(40.0,2.5,1.0)
	return
	
func attack2():
	left.back()
	yield(right.back(),"completed")
	for i in 3:
		left.clap(-1)
		yield(right.clap(1),"completed")
		launch_debris()
	yield(Global.timer(0.5),"timeout")
	left.back()
	yield(right.back(),"completed")

func launch_debris():
	for i in 8:
		var debris = preload("res://characters/boss/debris/debris.tscn").instance()
		get_parent().add_child(debris)
		debris.global_position.x = global_position.x + (randf()-0.5)*850
		debris.global_position.y = -150
		yield(Global.timer(0.2),"timeout")

func attack3():
	left.align_to_wall()
	yield(right.align_to_wall(),"completed")
	var r = randi()%2
	var first = [left,right][r]
	var second = [left,right][1-r]
	yield(first.hit_wall(),"completed")
	for i in 2:
		yield(Global.timer(0.45),"timeout")
		yield(second.hit_wall(),"completed")
		yield(Global.timer(0.45),"timeout")
		yield(first.hit_wall(),"completed")
	yield(Global.timer(0.5),"timeout")
	left.back()
	yield(right.back(),"completed")

	
	
