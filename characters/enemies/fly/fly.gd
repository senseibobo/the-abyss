extends Enemy

enum STATE {
	IDLE,
	CHASING
}

var velocity: Vector2
var acceleration: float = 100.0
var deceleration: float = 200.0
var state: int = STATE.IDLE

export var vision_range: float = 250.0

func hit():
	$HitParticles.emitting = true
	health -= 40.0
	if health <= 0.0:
		death()
	var will_pos = Global.will.global_position
	velocity += will_pos.direction_to(global_position)*Global.will.attacking.charge_amount*150.0

func _physics_process(delta: float) -> void:
	match state:
		STATE.CHASING:
			var dir = global_position.direction_to(Global.player.global_position)
			if velocity.dot(dir) > 0.0:
				velocity += dir*acceleration*delta
			else:
				velocity += dir*deceleration*delta
		STATE.IDLE:
			velocity = velocity.move_toward(Vector2(),deceleration*delta)
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)/2.0
	
func _process(delta):
	match state:
		STATE.IDLE:
			var dist = Global.player.global_position.distance_to(global_position)
			if dist < vision_range:
				state = STATE.CHASING
	
func death():
	var particles = preload("res://characters/enemies/fly/flydeathparticles.tscn").instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	.death()
