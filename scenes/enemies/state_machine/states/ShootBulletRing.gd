extends State

class_name ShootBulletRing

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var bullet_count: int = 7
@export var offset: int
@export var animation: String
@export var sound: String
@export var final_frame: int
@export var next_state: State
@export_category("Optional Randomness")
@export var bullet_count_min: int
@export var bullet_count_max: int
@export var random_offset: bool

var can_attack: bool

func bullet_ring():
	var actual_offset: float
	if offset != 0:
		actual_offset = (360 / offset) / 2
	for i in range(bullet_count):
		var angle = deg_to_rad(i * 360 / bullet_count) + deg_to_rad(actual_offset)
		var bullet = bullet_scene.instantiate()
		bullet.angle = angle
		bullet.position = enemy.cast_point.global_position
		get_tree().current_scene.add_child(bullet)
	if sound:
		MusicPlayer.call(sound)

func Enter() -> void:
	can_attack = true
	if bullet_count_min != 0 and bullet_count_max != 0:
		bullet_count = randi_range(bullet_count_min, bullet_count_max)
	if random_offset:
		offset = randi_range(1, 360)
	
func Update(_delta: float) -> void:
	enemy.nav.target_position = GlobalVariables.player_position
	if can_attack:
		if enemy.line_of_sight(enemy.cast_point.global_position, enemy.nav.target_position):
			bullet_ring()
			can_attack = false
			if animation:
				enemy.animations.play(animation)
	
	if enemy.animations.animation == animation:
		if enemy.animations.frame == final_frame:
			Transitioned.emit(self, next_state)
	else:
		Transitioned.emit(self, next_state)
