extends Area2D

@export var event: String
var index: int
var can_interact: bool

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		can_interact = false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		DialogueManager.play_dialogue(event, self)
