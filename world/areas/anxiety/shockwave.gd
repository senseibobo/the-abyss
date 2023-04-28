extends Node2D

func _ready():
	start_shockwave()
	mat.shader = mat.shader.duplicate()
	$Area2D/CollisionShape2D.shape = shape.duplicate()
	shape = $Area2D/CollisionShape2D.shape
	shape.radius = 1.0

onready var mat = $CanvasLayer/ColorRect.material
onready var shape = $Area2D/CollisionShape2D.shape

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	print(global_position-Global.camera.global_position)
	print(get_viewport().get_size())
	mat.set_shader_param("size",time*get_viewport().get_size().x/1280.0)
	mat.set_shader_param("global_position",global_position-Global.camera.global_position/Global.camera.zoom + get_viewport().get_size()/2.0)
	mat.set_shader_param("screen_size",get_viewport().get_size())

func start_shockwave():
	var tween = create_tween().set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.tween_property(mat,"shader_param/size",20.0,20.0)
	tween.tween_property(shape,"radius",1.1*get_viewport().get_size().x,4.0)
	yield(tween,"finished")
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	body.shockwaved()
