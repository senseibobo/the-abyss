extends Area2D
class_name PlayerHitter

func _ready():
	collision_mask = 2

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		hit_player(body)

func hit_player(player):
	player.hit()
