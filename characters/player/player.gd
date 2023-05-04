extends Character
class_name Player

enum STATE {
	AIR,
	WALKING,
	LAUNCHED,
	ATTACHED,
	INACTIVE
}

onready var cr = $ColorRect

export(STATE) var state: int = STATE.AIR
var velocity: Vector2
var gravity: float = 800.0
var jump_height: float = 300.0
var move_speed: float = 150.0
#export var active: bool = true

func _physics_process(delta: float) -> void:
	if dead: return
	var move = Input.get_axis("move_left","move_right")
	match state:
		STATE.AIR:
			velocity.x = move*move_speed
			velocity.y += gravity*delta
			velocity = move_and_slide(velocity,Vector2.UP)
			if is_on_floor():
				state = STATE.WALKING
		STATE.WALKING:
			velocity.x = move*move_speed
			velocity.y += gravity*delta
			velocity = move_and_slide(velocity,Vector2.UP)
			if Input.is_action_pressed("jump"):
				velocity.y = -jump_height
				state = STATE.AIR
			elif not is_on_floor():
				state = STATE.AIR
		STATE.LAUNCHED:
			velocity.y += gravity*delta*2.0
			velocity = move_and_slide(velocity,Vector2.UP)
			if get_slide_count() > 0:
				state = STATE.AIR
		STATE.ATTACHED:
			var old_pos = global_position
			global_position = Global.will.global_position - Global.will.offset_travelling*0.8
			if delta != 0:
				velocity = (global_position - old_pos)/delta
			if test_move(get_transform(),Vector2()) or Input.is_action_just_pressed("jump"):
				detach_from_will()
func _process(delta: float) -> void:
	ui.update_health(health)
	if dead: return
	hit_timer = move_toward(hit_timer, 0.0, delta)

var ui

func _ready():
	ui = preload("res://global/ui.tscn").instance()
	add_child(ui)
	Global.player = self
	#add_camera()

var crippled = false


func shockwaved():
	var sp = move_speed
	move_speed /= 3
	crippled = true
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"move_speed",sp,2.0)
	tween.tween_property(self,"crippled",true,0.0)
	Global.camera.shake(20.0,3.0,1.0)
	

#func add_camera():
#	var camera = preload("res://player/camera/playercamera.gd").new()
#	get_parent().call_deferred("add_child",camera)
#	camera.player = self
#	camera.name = "PlayerCamera"
#	camera.current = true

func attach_to_will():
	state = STATE.ATTACHED
func detach_from_will():
	state = STATE.LAUNCHED
	Global.will.player_detached()
	
	
var hit_timer: float = 0.0
var hit_invincibility: float = 0.5

func hit(amount: float = 20.0):
	if dead: return
	if hit_timer > 0: return
	health -= 20.0
	if health <= 0.0:
		death()
	hit_timer = hit_invincibility
	$HitOverlay/ColorRect.color = Color.red
	var tween = create_tween().set_parallel(true)
	cr.color = Color.red
	tween.tween_property(cr,"color",Color.white,0.2)
	tween.tween_property($HitOverlay/ColorRect,"color",Color(1.0,0.0,0.0,0.0),0.3)
	Global.camera.shake(7,2.0,0.3)
	print("the player has been hit.")


var dead: bool = false
func death():
	var tween = create_tween()
	tween.tween_property(Engine,"time_scale",0.2,0.5)
	dead = true
	$DeathParticles.emitting = true
	$ColorRect.visible = false
	tween = create_tween()
	tween.tween_property($Light2D,"texture_scale",0.0,0.5)
	var death = preload("res://mechanics/death.tscn").instance()
	get_parent().add_child(death)
	
