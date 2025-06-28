extends Node

var dialogues: Dictionary
signal show_dialogue(character_name: String, image: Texture, text: String, choices: Array)

func _ready() -> void:
	var dialogue_file = FileAccess.open("res://dialogue/dialogues.json", FileAccess.READ)
	dialogues = JSON.parse_string(dialogue_file.get_as_text())
	
func play_dialogue(event: String, trigger: Area2D):
	var dialogue = dialogues[event]
	show_dialogue.emit(dialogue["name"], load("res://dialogue/sprites/" + dialogue["image"]), \
	dialogue["dialogue"][trigger.index], dialogue["dialogue"][trigger.index]["choices"])
	
