extends CanvasLayer

var heart_size: Vector2 = Vector2(50, 50)

var choice_button: PackedScene = preload("res://dialogue/choice_button.tscn")

func _ready() -> void:
	GlobalVariables.player_hit.connect(Callable(self, "_on_player_hit"))
	update_health()
	
	DialogueManager.show_dialogue.connect(Callable(self, "_on_dialogue_show"))

func update_health() -> void:
	for heart in $HealthBar.get_children():
		heart.queue_free()
	for i in range(GlobalVariables.player_health / 2):
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_full.png")
		$HealthBar.add_child(heart)
	if (GlobalVariables.player_health % 2) != 0:
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_half.png")
		$HealthBar.add_child(heart)
	for i in range((GlobalVariables.player_max_health / 2) - ceil(GlobalVariables.player_health / 2.0)):
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_empty.png")
		$HealthBar.add_child(heart)

func _on_player_hit() -> void:
	update_health()

func _on_dialogue_show(character_name: String, text: String, image: Texture, choices: Array):
	$DialogueBox/Name.text = character_name
	$DialogueBox/Image.texture = image
	await type_text(text)
	show_choices(choices)
	
func type_text(full_text: String) -> void:
	$DialogueBox/Text.text = ""
	for i in range(full_text.length()):
		$DialogueBox/Text.text += full_text[i]
		await get_tree().create_timer(0.03).timeout
		
func show_choices(choices: Array):
	if choices:
		for choice in choices:
			var button = choice_button.instantiate()
			button.text = choice["text"]
			button.next = choice["next"]
			$Choices.add_child(button)
		$Choices.get_child(0).grab_focus()
