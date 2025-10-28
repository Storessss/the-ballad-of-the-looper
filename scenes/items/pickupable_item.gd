extends Node2D

@export var item_scene: PackedScene

var can_interact: bool

var items: Array[PackedScene] = [
	preload("res://scenes/items/weapons/fire_staff.tscn"),
	preload("res://scenes/items/weapons/water_staff.tscn"),
	preload("res://scenes/items/weapons/shade_staff.tscn"),
	preload("res://scenes/items/weapons/light_staff.tscn"),
	preload("res://scenes/items/weapons/air_staff.tscn"),
	preload("res://scenes/items/weapons/earth_staff.tscn"),
	preload("res://scenes/items/weapons/plant_staff.tscn"),
	preload("res://scenes/items/weapons/mushroom_staff.tscn"),
	preload("res://scenes/items/potions/health_potion.tscn"),
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
		MusicPlayer.item_get()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = false
