extends Enemy

var velocity: Vector2
var acceleration: float = 100.0
var deceleration: float = 200.0


func hit():
	$Particles2D.emitting = true
	health -= 40.0
	if health <= 0.0:
		death()
	var will_pos = Global.will.global_position
	velocity += will_pos.direction_to(global_position)*Global.will.attacking.charge_amount*150.0



func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(Global.player.global_position)
	if velocity.dot(dir) > 0.0:
		velocity += dir*acceleration*delta
	else:
		velocity += dir*deceleration*delta
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)/2.0
	
