extends Button

var event: String
var next: int

func _on_pressed() -> void:
	DialogueManager.play_dialogue(event, null, next)
