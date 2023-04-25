extends Character
class_name Enemy

func hit():
	print("hit")

func _ready() -> void:
	Global.enemies.append(self)

func _exit_tree() -> void:
	Global.enemies.erase(self)
