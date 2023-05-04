extends Enemy

enum STATE {
	IDLE,
	CHARGING,
	CHARGED,
	DASHING
}

var state: int = STATE.IDLE

var dash_speed: float = 1000.0
var dash_range: float = 340.0 #150 + 50
var charge_amount: float
var charge_speed: float = 1.6

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
		STATE.CHARGING:
			$Sprite.rotation = lerp_angle($Sprite.rotation,get_angle_to(Global.player.global_position),8*delta)
			charge_amount += charge_speed*delta
			$Light2D.energy = charge_amount
			if charge_amount >= 1.0:
				state = STATE.CHARGED
		STATE.CHARGED:
			charge_amount += charge_speed*delta
			if charge_amount >= 1.4:
				dash()
			
	
func dash():
	state = STATE.DASHING
	charge_amount = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var dir = Vector2.RIGHT.rotated($Sprite.rotation)
	var dest = global_position + dir*dash_range
	var tween2 = create_tween()
	tween.tween_property(self,"global_position",dest,0.4)
	tween.tween_property(self,"state",STATE.CHARGING,0.0)
	tween2.tween_property($Light2D,"energy",0.0,0.2)
	 
	
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
