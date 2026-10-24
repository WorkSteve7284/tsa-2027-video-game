extends Label

func _on_ship_speed(new_speed: float) -> void:
	text = "%.2f m/s" % new_speed
