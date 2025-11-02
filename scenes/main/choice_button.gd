extends Button

var choice_text: String
var choice_data: Dictionary
# Var to avoid final letter clipping when pressed
var fix_size: bool = true

func _on_pressed() -> void:
	for choice in get_parent().get_children():
		choice.queue_free()
	DialogueManager.next_dialogue.emit(choice_data)

func _process(delta: float) -> void:
	if fix_size:
		fix_size = false
		size.x += 10
		position.x -= 5
