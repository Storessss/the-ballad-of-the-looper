extends CanvasModulate

var hue: float = 0.0

func _process(delta: float) -> void:
	hue = fmod(hue + delta * 0.3, 1.0)
	color = Color.from_hsv(hue, 1.0, 1.0)
