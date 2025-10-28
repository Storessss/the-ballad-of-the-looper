extends Potion

var empty_health_potion_scene: PackedScene = preload("res://scenes/items/weapons/empty_health_potion.tscn")

func effect() -> void:
	GlobalVariables.player_health += 3
	GlobalVariables.player_health_changed.emit()
	GlobalVariables.replace_in_inventory(empty_health_potion_scene)
	GlobalVariables.player.instantiate_item()
