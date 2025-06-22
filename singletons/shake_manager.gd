extends Node

var sources: Array
var rnd: RandomNumberGenerator = RandomNumberGenerator.new()

func add_shake(strength: float, node: Node2D, fade_speed: float = 5.0) -> void:
	sources.append({
		"strength": strength,
		"node": node,
		"fade": fade_speed
	})

func _process(delta: float) -> void:
	for i in sources.size():
		sources[i]["strength"] = lerpf(sources[i]["strength"], 0, sources[i]["fade"] * delta)
		if sources[i]["strength"] < 0.1:
			sources.remove_at(i)

	if sources.size() > 0:
		for i in sources.size():
			sources[i]["node"].position += Vector2(
				rnd.randf_range(-sources[i]["strength"], sources[i]["strength"]),
				rnd.randf_range(-sources[i]["strength"], sources[i]["strength"])
			)
