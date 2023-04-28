extends Node

var slimes_left: int = 6
var flies_left: int = 15

var active: bool = false
var done: bool = false

var slimer: float = 0.0
var flimer: float = 0.0

var slime_cd: float = 10.0
var fly_cd = 4.0

var start_child_count: int

func _ready() -> void:
	start_child_count = get_child_count()

func _process(delta: float) -> void:
	if done and get_child_count() == start_child_count:
		get_parent().finished()
		done = false
		print("actually done")
	if not active: return
	slimer -= delta
	flimer -= delta
	if slimer <= 0.0 and slimes_left > 0:
		var slime = preload("res://characters/enemies/slime/slime.tscn").instance()
		add_child(slime)
		slime.global_position = get_node("SlimeSpawn" + str(randi()%2+1)).global_position
		slime.vision_range = 100000
		slimer += slime_cd
		slimes_left -= 1
	if flimer <= 0.0 and flies_left > 0:
		var fly = preload("res://characters/enemies/fly/fly.tscn").instance()
		add_child(fly)
		fly.global_position = get_node("FlySpawn" + str(randi()%3+1)).global_position
		flimer += fly_cd
		fly.vision_range = 100000
		flies_left -= 1
	if slimes_left <= 0 and flies_left <= 0:
		active = false
		done = true
		print("done")

func start():
	active = true


func _on_AnxietyS_body_entered(body: Node) -> void:
	start()
