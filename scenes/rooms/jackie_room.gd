extends SafePlace

var loop_event: String

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 2:
		$Jackie/Jackie/DialogueTrigger.event = "jackie1_1"
	elif GlobalVariables.fight_room_index == 4:
		$Jackie/Jackie/DialogueTrigger.event = "jackie2_1"
	loop_event = "jackie_loop1"
