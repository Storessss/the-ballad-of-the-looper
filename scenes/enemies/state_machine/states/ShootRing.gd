extends State

class_name ShootRing

@export var enemy: Enemy
@export var bullet_scene: PackedScene
@export var bullet_count: int = 7
@export var offset: int
@export var animation: String
@export var final_frame: int
@export var next_state: String

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

func Enter() -> void:
	can_attack = true
	
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
