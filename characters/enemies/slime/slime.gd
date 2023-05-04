extends Enemy

enum STATE {
	IDLE,
	CHARGING,
	JUMPING,
	FALLING
}

var state: int = STATE.FALLING

var velocity: Vector2

var jump_speed: float = 100.0
var jump_height: float = 300.0
var knockback_speed: float = 50.0
var gravity: float = 800.0
var charge_amount: float
var charge_speed: float = 1.0

export var vision_range: float = 200.0

func hit(amount: float = 20.0):
	$HitParticles.emitting = true
	health -= 40.0
	if health <= 0.0:
		death()
	var will_pos = Global.will.global_position


func _physics_process(delta: float) -> void:
	if global_position.y > 5000.0:
		death()
	match state:
		STATE.FALLING:
			$AnimationPlayer.play("idle")
			$AnimationPlayer.playback_speed = 1.0
			velocity.y += gravity*delta
			velocity.x = 0
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_floor():
				state = STATE.IDLE
		STATE.IDLE:
			$AnimationPlayer.play("idle")
			$AnimationPlayer.playback_speed = 1.0
			velocity.y += gravity*delta
			velocity.x = 0
			velocity = move_and_slide(velocity, Vector2.UP)
		STATE.CHARGING:
			$AnimationPlayer.playback_speed = charge_speed
			$AnimationPlayer.play("charge")
			charge_amount += charge_speed*delta
			velocity.y += gravity*delta
			velocity.x = 0
			if charge_amount >= 1.0:
				jump()
		STATE.JUMPING:
			$AnimationPlayer.play("jump")
			$AnimationPlayer.playback_speed = 1.0
			velocity.y += gravity*delta
			velocity.y = move_and_slide(velocity,Vector2.UP).y
			if is_on_floor():
				state = STATE.CHARGING
			
	
func jump():
	state = STATE.JUMPING
	charge_amount = 0.0
	velocity.y = -jump_height
	velocity.x = jump_speed * sign(Global.player.global_position.x - global_position.x)
	
func _process(delta):
	match state:
		STATE.IDLE:
			var dist = Global.player.global_position.distance_to(global_position)
			if dist < vision_range:
				state = STATE.CHARGING
	
func death():
	var particles = preload("res://characters/enemies/slime/slimedeathparticles.tscn").instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	.death()
