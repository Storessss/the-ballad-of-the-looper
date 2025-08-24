extends Enemy

class_name DungeonFlower

var target_ally: Enemy
var mark_flower_scene: PackedScene = preload("res://scenes/particles/mark_flower.tscn")

func bind() -> void:
	await get_tree().process_frame
	if GlobalVariables.dungeon_flower_targets.size() == 0:
		die()
	else:
		target_ally = GlobalVariables.dungeon_flower_targets.pick_random()
		GlobalVariables.dungeon_flower_targets.erase(target_ally)
		target_ally.health = 1000000
		var color = Color(randf(), randf(), randf(), 1.0)
		var mark_flower = mark_flower_scene.instantiate()
		mark_flower.color = color
		target_ally.add_child(mark_flower)
		mark_flower = mark_flower_scene.instantiate()
		mark_flower.color = color
		add_child(mark_flower)
	
func die():
	if can_die:
		if target_ally and target_ally != self:
			target_ally.die()
		super.die()
