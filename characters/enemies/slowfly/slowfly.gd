extends Enemy

enum STATE {
	IDLE,
	CHASING
}

var velocity: Vector2
var speed = 50.0
var state: int = STATE.IDLE

export var vision_range: float = 250.0

func hit(amount: float = 20.0):
	$HitParticles.emitting = true
	health -= 40.0
	if health <= 0.0:
		death()
	var will_pos = Global.will.global_position
	velocity += will_pos.direction_to(global_position)*Global.will.attacking.charge_amount*150.0

var time: float = 0.0

func _physics_process(delta: float) -> void:
	time += delta
	match state:
		STATE.CHASING:
			global_position = global_position.move_toward(Global.player.global_position,speed*(1+sin(time*50.0))*delta)
	
func _process(delta):
	match state:
		STATE.IDLE:
			var dist = Global.player.global_position.distance_to(global_position)
			if dist < vision_range:
				state = STATE.CHASING
	
func death():
	var particles = preload("res://characters/enemies/slowfly/slowflydeathparticles.tscn").instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	.death()
