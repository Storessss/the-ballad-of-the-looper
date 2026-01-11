extends Node

#var dialogue: Dictionary
#var dialogue_index: int
#var previous_event: String

var dialogue_file: FileAccess
var dialogue_index: int
var line_index: int
var characters: Dictionary = {
	"zaine": {
		"name": "Zaine",
		"portrait": "zaine_portrait.png"
	},
	"jackie": {
		"name": "Jackie",
		"portrait": "jackie_portrait.png"
	},
	"abbie": {
		"name": "Abbie",
		"portrait": "abbie_portrait.png"
	},
	"tom": {
		"name": "Tom",
		"portrait": "tom_portrait.png"
	},
}
var character_name: String
var portrait: Texture
var text: String 

signal play_dialogue(event: String)
signal show_dialogue(character_name: String, portrait: Texture, text: String, text_speed: float)
signal hide_dialogue

func _ready() -> void:
	dialogue_file = FileAccess.open("res://dialogue/dialogue.txt", FileAccess.READ)
	
	play_dialogue.connect(Callable(self, "_on_play_dialogue"))
	hide_dialogue.connect(Callable(self, "_on_hide_dialogue"))
	
func _on_play_dialogue(event: String = ""):
	dialogue_file.seek(0)
	if event:
		while not dialogue_file.eof_reached():
			dialogue_index += 1
			var line: String = dialogue_file.get_line().strip_edges()
			if line.is_empty():
				continue
			if line == event + "//":
				break
	dialogue_file.seek(0)
	for i in range(dialogue_index + line_index):
		if dialogue_file.eof_reached():
			break
		dialogue_file.get_line()
	var line = dialogue_file.get_line()
	line_index += 1
	if line == "//":
		hide_dialogue.emit()
		return
	elif line.is_empty():
		play_dialogue.emit()
		return
	text = line
	for key in characters.keys():
		if line.begins_with(key + "/"):
			character_name = characters[key]["name"]
			portrait = load("res://sprites/" + characters[key]["portrait"])
			text = line.split("/", false, 1)[1]
	show_dialogue.emit(character_name, portrait, text, 0.045)

func _on_hide_dialogue():
	dialogue_index = 0
	line_index = 0
