extends SafePlace

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 2:
		$Jackie/Jackie/DialogueTrigger.event = "jackie1"
	elif GlobalVariables.fight_room_index == 4:
		$Jackie/Jackie/DialogueTrigger.event = "jackie2"
	elif GlobalVariables.fight_room_index == 6:
		$Jackie/Jackie/DialogueTrigger.event = "jackie3"
	elif GlobalVariables.fight_room_index == 8:
		$Jackie/Jackie/DialogueTrigger.event = "jackie4"
	elif GlobalVariables.fight_room_index == 10:
		$Jackie/Jackie/DialogueTrigger.event = "jackie5"
	elif GlobalVariables.fight_room_index == 12:
		$Jackie/Jackie/DialogueTrigger.event = "jackie6"
