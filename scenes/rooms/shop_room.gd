extends SafePlace

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 4:
		$Abbie/DialogueTrigger.event = "abbie1_1"
	elif GlobalVariables.fight_room_index == 8:
		$Abbie/DialogueTrigger.event = "abbie2_1"
	elif GlobalVariables.fight_room_index == 12:
		$Abbie/DialogueTrigger.event = "abbie3_1"
