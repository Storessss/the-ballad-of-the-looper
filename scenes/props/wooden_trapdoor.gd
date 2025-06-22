extends Node2D

func _process(_delta):
	if get_tree().get_nodes_in_group("enemies").size() == 0 and $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("half_open")
		$OpeningTimer.start()
		$OpeningSound.play()

func _on_opening_timer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")
	ShakeManager.add_shake(20.0, GlobalVariables.player.get_node("Camera2D"), 5.0)

func _on_body_entered(body: Node2D) -> void:
	#RoomManager.call_deferred("change_room")
	pass
