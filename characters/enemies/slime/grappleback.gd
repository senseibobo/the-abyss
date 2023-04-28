extends GSC

var being_grappled: bool = false

func grappled_to():
	being_grappled = true
	print("grap")
	Global.will.return_line()
	Global.player.detach_from_will()

func _physics_process(delta: float) -> void:
	if being_grappled:
		if Global.will.state != Global.will.STATE.RETURNING:
			being_grappled = false
		else:
			get_parent().global_position = Global.will.line_pos
