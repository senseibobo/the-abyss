extends Character
class_name Enemy

func hit(amount: float = 20.0):
	print("hit")

func _ready() -> void:
	Global.enemies.append(self)

func _exit_tree() -> void:
	Global.enemies.erase(self)

func death():
	queue_free()
