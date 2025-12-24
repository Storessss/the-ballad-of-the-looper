extends Area2D

@export var event: String
@export var one_time: bool
var index: int
var can_interact: bool
var already_playing: bool

func _ready() -> void:
	DialogueManager.show_dialogue.connect(Callable(self, "_on_show_dialogue"))
	DialogueManager.hide_dialogue.connect(Callable(self, "_on_hide_dialogue"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = false

func _on_show_dialogue(character_name: String, portrait: Texture, text: String, text_speed: float):
	already_playing = true

func _on_hide_dialogue() -> void:
	already_playing = false
	if one_time:
		queue_free()

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact") and not already_playing:
		DialogueManager.play_dialogue.emit(event)
			
