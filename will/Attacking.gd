extends Node2D

var attack_timer: float = 0.0
var attack_cd: float = 0.4
var charging: bool = false
var charge_amount: float = 0.0
var charge_speed: float = 2.0

onready var charge = $Charge
onready var big_hit = $BigHit
onready var big_hit_area = $BigHitArea
onready var small_hit = $SmallHit
onready var small_hit_area = $SmallHitArea

func _process(delta: float) -> void:
	attack_timer = move_toward(attack_timer, 0.0, delta)
	if charging:
		charge_amount += charge_speed*delta
		if charge_amount >= 1.0 or Input.is_action_just_released("attack"):
			attack()
	else:
		if attack_timer <= 0.0:
			if Input.is_action_pressed("attack"):
				charging = true
				charge.emitting = true
				charge_amount = 0.0

func attack():
	Global.camera.shake(min(charge_amount,0.4)*20.0,2.0,1.0)
	attack_timer = attack_cd
	charging = false
	charge.restart()
	charge.emitting = false
	
	var hit_area
	
	if charge_amount >= 1.0:
		big_hit.emitting = true
		hit_area = big_hit_area
	else:
		small_hit.emitting = true
		hit_area = small_hit_area
		
	for body in hit_area.get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit()
		else:
			print("BODY " + body.name + " HAS NO HIT METHOD")
