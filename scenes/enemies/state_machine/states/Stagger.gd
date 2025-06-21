extends State

class_name Stagger

@onready var enemy: Enemy = get_parent().get_parent()
@export var health_treshold: int
@export var state_duration_min: float
@export var state_duration_max: float
@export var animation: String
@export var next_state: State

var initialized: bool

var previous_health: int
var state_duration: float
var staggered: bool

func Enter() -> void:
	await get_tree().process_frame
	if not initialized:
		initialized = true
		previous_health = enemy.health
	state_duration = randf_range(state_duration_min, state_duration_max)
	
	if not staggered:
		if (previous_health - enemy.health) >= health_treshold:
			staggered = true
			MusicPlayer.boss_stagger()
		else:
			previous_health = enemy.health
			Transitioned.emit(self, next_state)

func Update(delta: float) -> void:
	if staggered:
		enemy.direction = Vector2.ZERO
		if animation:
			enemy.animations.play(animation)
		if state_duration > 0:
			state_duration -= delta
		else:
			staggered = false
			previous_health = enemy.health
			Transitioned.emit(self, next_state)
