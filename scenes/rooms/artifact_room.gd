extends Room

var disengage_status: int
var loop_counter: int
var moment_of_consciousness: int = 310657

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
		$Hud.hide_stats()
	elif disengage_status == 1:
		disengage_status += 1
		
func _process(delta: float) -> void:
	if disengage_status >= 2:
		$LoopingCutscene.visible = true
		#$CanvasModulate.color = Color.WHITE
		$LoopingCutscene/ZaineLoop/EyeOfTheLooper.rotation += delta * 2
		$LoopingCutscene/ZaineLoop/EyeOfTheLooper2.rotation += delta * -2
		loop_counter += delta * 32000
		loop_counter = min(loop_counter, moment_of_consciousness)
		$LoopingCutscene/LoopsText.text = "Loop: " + str(loop_counter)
		if disengage_status == 3:
			$LoopingCutscene/LoopsTextBlinkingTimer.start()
	if loop_counter == moment_of_consciousness:
		disengage_status += 1
		await get_tree().create_timer(5.0).timeout
		GlobalVariables.change_room()

func _on_loops_text_blinking_timer_timeout() -> void:
	$LoopingCutscene/LoopsText.visible = not $LoopingCutscene/LoopsText.visible
