extends Button

var next: int

func _on_pressed() -> void:
	DialogueManager.play_choice(next)
	for button in get_parent().get_children():
		button.queue_free()
