extends Room

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 18:
		$Jackie/Jackie/DialogueTrigger.event = "tom1"
	elif GlobalVariables.fight_room_index == 32:
		$Jackie/Jackie/DialogueTrigger.event = "tom2"
		$Chest.queue_free()
