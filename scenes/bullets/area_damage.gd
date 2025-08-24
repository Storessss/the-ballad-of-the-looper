extends Area2D

class_name AreaDamage

@export var radius: int
var damage: int
@export var damage_time: float
@export var destroy_time: float = 0.6
@export var damage_over_time: bool
@export var damages_player: bool = true
@export var damages_enemies: bool = true

var in_area: Array[CharacterBody2D]

func _ready() -> void:
	$CollisionShape2D.shape.radius = 15.0
	$CollisionShape2D.shape.radius = ($CollisionShape2D.shape.radius * radius) + $CollisionShape2D.shape.radius
	
	$DamageTimer.start(damage_time)
	$DestroyTimer.start(destroy_time)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if damage_over_time:
			if body not in in_area:
				in_area.append(body)
		else:
			body.take_damage(damage)
	elif body.is_in_group("players"):
		if damage_over_time:
			if body not in in_area:
				in_area.append(body)
		else:
			body.take_damage()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if damage_over_time:
			if body in in_area:
				in_area.erase(body)
	elif body.is_in_group("players"):
		if damage_over_time:
			if body in in_area:
				in_area.erase(body)
		else:
			body.take_damage()

func _on_damage_timer_timeout() -> void:
	for body in in_area:
		if body.is_in_group("enemies"):
			body.take_damage(damage)
		elif body.is_in_group("players"):
			body.take_damage()

func _on_destroy_timer_timeout() -> void:
	queue_free()
