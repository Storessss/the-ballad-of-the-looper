extends Node2D

func _process(_delta):
	if $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("half_open")
		$OpeningTimer.start()
		$OpeningSound.play()

func _on_opening_timer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")
	GlobalVariables.player.shake = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		GlobalVariables.change_room()
