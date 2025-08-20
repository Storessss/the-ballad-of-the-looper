extends Area2D

var radius: int
var damage: int

func _ready() -> void:
	$CollisionShape2D.shape.radius = 15.0
	$CollisionShape2D.shape.radius = ($CollisionShape2D.shape.radius * radius) + $CollisionShape2D.shape.radius

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	if body.is_in_group("players"):
		body.take_damage()

func _on_destroy_timer_timeout() -> void:
	queue_free()
