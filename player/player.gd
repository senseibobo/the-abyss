extends KinematicBody2D
class_name Player

enum STATE {
	AIR,
	WALKING,
	LAUNCHED,
	ATTACHED,
	INACTIVE
}

export(STATE) var state: int = STATE.AIR
var velocity: Vector2
var gravity: float = 800.0
var jump_height: float = 300.0
var move_speed: float = 150.0
#export var active: bool = true

func _physics_process(delta: float) -> void:
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
			print(velocity)
			if test_move(get_transform(),Vector2()) or Input.is_action_just_pressed("jump"):
				detach_from_will()


func _ready():
	Global.player = self
	#add_camera()

func add_camera():
	var camera = preload("res://player/PlayerCamera.gd").new()
	get_parent().call_deferred("add_child",camera)
	camera.player = self
	camera.name = "PlayerCamera"
	camera.current = true

func attach_to_will():
	state = STATE.ATTACHED
func detach_from_will():
	state = STATE.LAUNCHED
	Global.will.player_detached()
	
	
	
		
	
