extends Room

func _ready() -> void:
	super._ready()
	
	if GlobalVariables.fight_room_index == 4:
		$Abbie/DialogueTrigger.event = "abbie1"
	elif GlobalVariables.fight_room_index == 8:
		$Abbie/DialogueTrigger.event = "abbie2"
	elif GlobalVariables.fight_room_index == 12:
		$Abbie/DialogueTrigger.event = "abbie3"
	elif GlobalVariables.fight_room_index == 16:
		$Abbie/DialogueTrigger.event = "jackie&abbie1"
		$Jackie.visible = true
		$Abbie.animation = "happy"
		$Abbie/Halo.visible = true
		$Abbie/AnimationPlayer.play("abbie")
		MusicPlayer.change_music(preload("res://music/Safe Place.ogg"))
