extends Node2D

@export var item_scene: PackedScene

var can_interact: bool

var items: Array[PackedScene] = [
	preload("res://scenes/weapons/sword.tscn"),
	preload("res://scenes/weapons/fire_staff.tscn"),
	preload("res://scenes/weapons/water_staff.tscn"),
	preload("res://scenes/weapons/shade_staff.tscn"),
	preload("res://scenes/weapons/light_staff.tscn"),
	preload("res://scenes/weapons/air_staff.tscn"),
	preload("res://scenes/weapons/earth_staff.tscn"),
	preload("res://scenes/weapons/plant_staff.tscn"),
	preload("res://scenes/weapons/mushroom_staff.tscn"),
]

func _ready() -> void:
	if not item_scene:
		item_scene = items.pick_random()
	var item: Node2D = item_scene.instantiate()
	$Sprite2D.texture = item.get_node("Sprite2D").texture
	 
	$Sprite2D.rotation = randi_range(1, 360)
		
func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		GlobalVariables.append_to_inventory(item_scene)
		#GlobalVariables.inventory_index = GlobalVariables.inventory.size() - 1
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = false
