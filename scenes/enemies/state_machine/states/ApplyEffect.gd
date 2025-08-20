extends State

class_name ApplyEffect

@onready var enemy: Enemy = get_parent().get_parent()
@export_enum("ONE_HP") var effect := "ONE_HP"
@export var modulate_color: Color = Color.WHITE
@export var next_state: State


func Enter() -> void:
	if effect == "ONE_HP":
		enemy.health = 1
	enemy.default_modulate = modulate_color
	enemy.modulate = modulate_color
	Transitioned.emit(self, next_state)
