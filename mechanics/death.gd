extends CanvasLayer

const messages = [
	"Failure is just a stepping stone to success.\nPress R to try again.",
	"Your perseverance will pay off.\nPress R to try again.",
	"Practice makes perfect.\nPress R to try again.",
	"Failure is not the end, it's just the beginning.\nPress R to try again.",
	"Failure is not falling down, it's staying down.\nPress R to try again.",
	"A setback is just a setup for a comeback.\nPress R to try again.",
	"Every failure is a chance to learn and improve.\nPress R to try again."
]

func _ready() -> void:
	var tween = create_tween()
	$VBoxContainer.modulate.a = 0.0
	tween.tween_property($VBoxContainer,"modulate:a", 1.0, 0.3)
	var effects = ["center","tornado radius=2.0 freq=3.0"]
	var text = "\n\n" + messages[randi()%messages.size()]
	for i in effects.size():
		var effect = effects[i]
		text = "[" + effect + "]" + text
		text += "[/" + effect.split(' ')[0] + "]"
	$VBoxContainer/Message2.bbcode_text = text

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		Transition.restart_scene()
