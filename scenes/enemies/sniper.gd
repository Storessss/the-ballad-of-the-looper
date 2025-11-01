extends Enemy

var small_explosion_scene: PackedScene = preload("res://scenes/bullets/small_explosion.tscn")
var default_cast_point_position: Vector2 = Vector2(2.5, 0)

func die() -> void:
	if can_die:
		var small_explosion: AreaDamage = small_explosion_scene.instantiate()
		small_explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", small_explosion)
		super.die()

func _process(delta: float) -> void:
	super._process(delta)
	animations.flip_h = false
