extends Node2D

var can_interact: bool
var pickupable_scene: PackedScene = preload("res://scenes/items/pickupable_item.tscn")
@export var override_item_drops: Array[PackedScene]

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("interact") and $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("opening")
		$ChestOpening.play()
	if $AnimatedSprite2D.animation == "opening" and $AnimatedSprite2D.frame == 3:
		$AnimatedSprite2D.play("open")
		var pickupable: Area2D = pickupable_scene.instantiate()
		pickupable.global_position = global_position
		if override_item_drops:
			pickupable.items = override_item_drops
		get_tree().current_scene.add_child(pickupable)
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = false
