extends Node2D
class_name Will

enum THROW {
	NONE,
	GRAPPLE,
	SWING
}

onready var player = Global.player
export var offset_from_player: Vector2 = Vector2(0,-40)
export var offset_travelling: Vector2 = Vector2(0,-28)
export var radius: Vector2 = Vector2(10,5)

onready var line: Line2D = $Line2D
var line_travelling: bool = false
var line_returning: bool = false
var line_travelled: float = 0.0
var line_pos: Vector2
var line_dir: Vector2
var line_speed: float = 1000.0
var line_return_speed: float = 1500.0
var max_line_travel_grapple: float = 600.0
var max_line_travel_swing: float = 300.0
var throw_mode: int = THROW.NONE
var grappling: bool = false
var swinging: bool = false
var cd: float = 0.0
var cd_time: float = 1.5
var current_swing: float = 0.0
var swing_radius: float = 0.0
var grapple_speed: float = 800.0
export var active: bool = true

func _ready() -> void:
	line.set_as_toplevel(true)
	line.global_position = Vector2()
	line.visible = false
	Global.will = self

func _physics_process(delta: float) -> void:
	#if not is_instance_valid(Global.player): return
	if not active: return
	var dest
	if grappling:
		global_position = global_position.move_toward(line_pos,grapple_speed*delta)
		if global_position.distance_to(line_pos) < 10.0:
			grappling = false
			return_line()
	elif swinging:
		global_position = line_pos + Vector2.DOWN.rotated(sin(current_swing)/2.0*PI*0.8)*swing_radius
		current_swing += (1000-swing_radius)/320.0*delta
	elif line_travelling:
		dest = Global.player.global_position + offset_travelling
		global_position = global_position.linear_interpolate(dest,20*delta)
	else:
		var center = Global.player.global_position + offset_from_player
		var spin = Vector2.ONE.rotated(OS.get_ticks_msec()/300.0)*radius
		dest = center+spin
		global_position = global_position.linear_interpolate(dest,5*delta)

func _process(delta):
	if not active: return
	cd = move_toward(cd,0,delta)
	if line_travelling:
		line_travelled += line_speed*delta
		var old_pos = line_pos
		var new_pos = line_pos + line_dir*line_speed*delta
		line_pos = new_pos
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(old_pos, new_pos, [], 1)
		if result:
			print("ersutl")
			var body = result.collider
			match throw_mode:
				THROW.GRAPPLE:
					if body.grapple:
						body.grappled_to()
						grappling = true
						Global.player.attach_to_will()
						stop_line()
					else:
						return_line()
				THROW.SWING:
					if body.swing:
						body.swung_from()
						swinging = true
						start_swing()
						Global.player.attach_to_will()
						stop_line()
					else:
						return_line()
				_:
					return_line()
		elif line_travelled > (max_line_travel_grapple if throw_mode == THROW.GRAPPLE else max_line_travel_swing):
			return_line()
	elif line_returning:
		line_pos = line_pos.move_toward(global_position, line_return_speed*delta)
		if line_pos.distance_to(global_position) < 10.0:
			line_returning = false
			line.visible = false
	update_line_points()
	
	if Input.is_action_just_pressed("grapple") and is_available():
		throw_mode = THROW.GRAPPLE
		swinging = false
		grappling = false
		throw_line()
	if Input.is_action_just_pressed("swing") and is_available():
		print("sw")
		swinging = false
		grappling = false
		throw_mode = THROW.SWING
		throw_line()
		
func start_swing():
	var radius = global_position.distance_to(line_pos)
	var angle = line_pos.angle_to_point(global_position)
	swing_radius = radius
	current_swing = cos(angle)
	if (global_position.x - line_pos.x) < 0:
		current_swing = PI-current_swing
	

func return_line():
	line_returning = true
	line_travelling = false
	swinging = false
	grappling = false

func throw_line():
	cd = cd_time
	line_travelling = true
	line_travelled = 0
	line_pos = global_position
	line_dir = global_position.direction_to(get_global_mouse_position())
	update_line_points()
	line.set_deferred("visible", true)

func stop_line():
	line_travelling = false
	line_returning = false

func update_line_points():
	line.points = [global_position,line_pos]

func player_detached():
	return_line()

func is_available():
	return not grappling and not line_travelling and not line_returning and not cd > 0.0
