extends State

class_name ApplyEffect

@onready var enemy: Enemy = get_parent().get_parent()
@export_enum("ONE_HP", "INVINCIBLE", "NON_INVINCIBLE") var effect: String = "ONE_HP"
@export var modulate_color: Color = Color.WHITE
@export var animation: String
@export var next_state: State

func Enter() -> void:
	await get_tree().process_frame
	if effect == "ONE_HP":
		enemy.health = 1
	elif effect == "INVINCIBLE":
		enemy.invincible = true
	elif effect == "NON_INVINCIBLE":
		enemy.invincible = false
	enemy.default_modulate = modulate_color
	enemy.modulate = modulate_color
	if animation:
		enemy.animations.play(animation)
	Transitioned.emit(self, next_state)
