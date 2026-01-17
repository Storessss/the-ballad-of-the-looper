extends Room

var reflection_rooms: Array[int] = [24, 26, 28]

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 2:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie1"
	elif GlobalVariables.fight_room_index == 4:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie2"
	elif GlobalVariables.fight_room_index == 6:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie3"
	elif GlobalVariables.fight_room_index == 10:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie4"
	elif GlobalVariables.fight_room_index == 12:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie5"
	elif GlobalVariables.fight_room_index == 14:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie6"
	elif GlobalVariables.fight_room_index == 20:
		$JackieItems/Jackie/DialogueTrigger.event = "jackie8"
	elif GlobalVariables.fight_room_index == 22:
		$JackieItems/Jackie.visible = false
		MusicPlayer.change_music(preload("res://music/We Now.ogg"))
	elif GlobalVariables.fight_room_index == 24:
		$Statue/DialogueTrigger.event = "zaine1"
	elif GlobalVariables.fight_room_index == 26:
		$Statue/DialogueTrigger.event = "zaine2"
	elif GlobalVariables.fight_room_index == 28:
		$Statue/DialogueTrigger.event = "zaine4"
		
	if GlobalVariables.fight_room_index == 18 or GlobalVariables.fight_room_index > 22:
		$JackieItems.queue_free()
	if GlobalVariables.fight_room_index != 18:
		$Tom.queue_free()
	if GlobalVariables.fight_room_index not in reflection_rooms:
		$Statue.queue_free()
