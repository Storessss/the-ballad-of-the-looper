extends Enemy

var small_explosion_scene: PackedScene = preload("res://scenes/bullets/small_explosion.tscn")

func die() -> void:
	if can_die:
		var small_explosion: AreaDamage = small_explosion_scene.instantiate()
		small_explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", small_explosion)
		super.die()
