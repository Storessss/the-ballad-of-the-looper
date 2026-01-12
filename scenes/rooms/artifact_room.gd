extends Room

var disengage_status: int

func _ready() -> void:
	super._ready()
	DialogueManager.hide_dialogue.connect(Callable(self, "_on_hide_dialogue"))
	
func _on_hide_dialogue():
	if disengage_status == 0:
		disengage_status += 1
		$Jackie/DialogueTrigger.queue_free()
		MusicPlayer.change_music(preload("res://music/ERROR.ogg"))
		DialogueManager.play_dialogue.emit("ERROR")
		$Disengaged.visible = true
	elif disengage_status == 1:
		disengage_status += 1
		GlobalVariables.change_room()
