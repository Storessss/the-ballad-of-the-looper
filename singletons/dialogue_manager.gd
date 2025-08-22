extends Node

var dialogues: Dictionary
signal show_dialogue(character_name: String, image: Texture, text: String, choices: Array, \
font: FontFile)
var end_text: bool = true
signal hide_dialogue()
var end_dialogue: bool

var choice: bool
var previous_event: String
var previous_trigger: Area2D

func _ready() -> void:
	var dialogue_file = FileAccess.open("res://dialogue/dialogues.json", FileAccess.READ)
	dialogues = JSON.parse_string(dialogue_file.get_as_text())
	
func play_dialogue(event: String, trigger: Area2D):
	var dialogue = dialogues[event]
	var selected_dialogue = dialogue["dialogue"][trigger.index]
	
	var font = preload("res://styles/Retro Gaming.ttf")
	if dialogue.has("looping"):
		font = preload("res://styles/Retro Gaming.ttf")
	
	if selected_dialogue.has("choices"):
		show_dialogue.emit(dialogue["name"], load("res://sprites/" + dialogue["image"]), \
		selected_dialogue["text"], selected_dialogue["choices"], font)
		choice = true
		previous_event = event
		previous_trigger = trigger
	else:
		show_dialogue.emit(dialogue["name"], load("res://sprites/" + dialogue["image"]), \
		selected_dialogue["text"], [], font)
		trigger.index += selected_dialogue["next"]
		
	if selected_dialogue.has("end"):
		end_dialogue = true
		
func play_choice(next: int):
	choice = false
	previous_trigger.index += next
	play_dialogue(previous_event, previous_trigger)
