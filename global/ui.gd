extends CanvasLayer



func update_health(health):
	$Healthbar.value = health
	if health >= 80:
		$Healthbar.tint_progress = Color.green
	elif health >= 40:
		$Healthbar.tint_progress = Color.orange
	else:
		$Healthbar.tint_progress = Color.red
