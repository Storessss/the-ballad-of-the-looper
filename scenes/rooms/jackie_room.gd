extends SafePlace

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.room == 2:
		$Jackie/Jackie/DialogueTrigger.event = "jackie1_1"
	elif GlobalVariables.room == 4:
		$Jackie/Jackie/DialogueTrigger.event = "jackie2_1"
		
	GlobalVariables.room -= 1
