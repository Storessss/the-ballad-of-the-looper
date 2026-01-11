extends Control

var typing: bool
var skip_text: bool
var text_box: RichTextLabel
var last_visible_chars: int = 0

const choice_button_scene: PackedScene = preload("res://scenes/main/choice_button.tscn")

func _ready() -> void:
	DialogueManager.show_dialogue.connect(Callable(self, "_on_show_dialogue"))
	DialogueManager.hide_dialogue.connect(Callable(self, "_on_hide_dialogue"))

func _on_show_dialogue(character_name: String, portrait: Texture, text: String, text_speed: float):
	$DialogueBox.visible = true
	$DialogueBox/Name.text = character_name
	if portrait:
		$DialogueBox/Portrait.texture = portrait
		$DialogueBox/Background.visible = true
		text_box = $DialogueBox/Text
	else:
		$DialogueBox/Background.visible = false
		text_box = $DialogueBox/FullWidthText
	await type_text(text, text_speed)
	
func type_text(text: String, text_speed: float = 0.025) -> void:
	typing = true
	skip_text = false
	last_visible_chars = 0

	text_box.clear()
	text_box.text = text

	text_box.visible_characters = 0
	var total_chars = text_box.get_total_character_count()

	var duration = total_chars * text_speed
	var tween = get_tree().create_tween()
	tween.tween_property(text_box, "visible_characters", total_chars, duration).from(0.0)

	while tween.is_running():
		if not get_tree():
			return
		await get_tree().process_frame
		if text_box.visible_characters > last_visible_chars:
			last_visible_chars = text_box.visible_characters
			MusicPlayer.text()
		if skip_text:
			tween.kill()
			text_box.visible_characters = -1
			break
	typing = false
	
func _process(_delta: float) -> void:
	if typing and Input.is_action_just_pressed("interact"):
		skip_text = true
	if not typing and Input.is_action_just_pressed("interact") and $DialogueBox.visible:
		$DialogueBox/Text.text = ""
		$DialogueBox/FullWidthText.text = ""
		DialogueManager.play_dialogue.emit()
		
func _on_hide_dialogue() -> void:
	$DialogueBox/Text.text = ""
	$DialogueBox/FullWidthText.text = ""
	$DialogueBox.visible = false
