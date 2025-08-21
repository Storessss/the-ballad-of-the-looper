extends Enemy

func die() -> void:
	if can_die:
		GlobalVariables.comp -= 1
		super.die()

func pass_on():
	if can_die:
		GlobalVariables.comp += 1
		super.die()

func _process(_delta: float) -> void:
	super._process(_delta)
	animations.flip_h = false
