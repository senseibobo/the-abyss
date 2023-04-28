extends Particles2D

func _ready():
	get_tree().create_timer(1.0,false).connect("timeout",self,"queue_free")
