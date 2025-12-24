extends Node

var dialogue: Dictionary
var dialogue_variables: Dictionary = {
	
}
var dialogue_index: int
var previous_event: String

signal play_dialogue(event: String)
signal show_dialogue(character_name: String, portrait: Texture, text: String, text_speed: float)
signal hide_dialogue
signal next_dialogue
signal show_choices(choices: Array)

func _ready() -> void:
	var dialogue_file = FileAccess.open("res://dialogue/dialogue.json", FileAccess.READ)
	dialogue = JSON.parse_string(dialogue_file.get_as_text())
	
	play_dialogue.connect(Callable(self, "_on_play_dialogue"))
	next_dialogue.connect(Callable(self, "_on_next_dialogue"))
	
func _on_play_dialogue(event: String):
	previous_event = event
	var selected_dialogue = dialogue[event]
	if selected_dialogue.has("branches"):
		for branch in selected_dialogue["branches"]:
			var var_name = branch["var"]
			var op = branch["operator"]
			var value = branch["value"]
			if dialogue_variables.has(var_name):
				if check_branch_condition(dialogue_variables[var_name], op, value):
					play_dialogue.emit(branch["next"])
					return
	var character_name = selected_dialogue.get("name", "")
	var portrait: Texture = null
	if selected_dialogue.has("portrait"):
		portrait = load("res://sprites/" + selected_dialogue["portrait"])
	var text = selected_dialogue.get("text", [""])
	var text_speed: float = selected_dialogue.get("text_speed", 0.045)
	if dialogue_index != text.size():
		text[dialogue_index] = replace_keywords(text[dialogue_index])
		show_dialogue.emit(character_name, portrait, text[dialogue_index], text_speed)
		dialogue_index += 1
	else:
		dialogue_index = 0
		if not selected_dialogue.has("choices"):
			if selected_dialogue.has("next"):
				play_dialogue.emit(selected_dialogue["next"])
			else:
				hide_dialogue.emit()
		else:
			show_choices.emit(selected_dialogue["choices"])
		
func _on_next_dialogue(choice: Dictionary = {}):
	if dialogue_index != 0:
		play_dialogue.emit(previous_event)
	elif choice != {}:
		if choice.has("set_var"):
			var set_var = choice["set_var"]
			for key in set_var.keys():
				dialogue_variables[key] = set_var[key]
		if choice.has("next"):
			play_dialogue.emit(choice["next"])
		else:
			hide_dialogue.emit()

func check_branch_condition(lhs, op: String, rhs) -> bool:
	match op:
		"==": return lhs == rhs
		"!=": return lhs != rhs
		"<":  return lhs < rhs
		"<=": return lhs <= rhs
		">":  return lhs > rhs
		">=": return lhs >= rhs
		_:    return false

var keywords: Dictionary = {
	"{dims}": GlobalVariables.dims,
}
func replace_keywords(text: String):
	for key in keywords.keys():
		text = text.replace(key, str(keywords[key]))
	return text
	
