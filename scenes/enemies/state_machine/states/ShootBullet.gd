extends State

class_name ShootBullet

@export var enemy: Enemy
@export var bullet_scene: PackedScene
@export var animation: String
@export var final_frame: int
@export var next_state: String

func shoot():
	var bullet = bullet_scene.instantiate()
	var point = GlobalVariables.player_position - enemy.global_position
	bullet.angle = point.angle()
	bullet.global_position = enemy.cast_point.global_position
	bullet.player_bullet = false
	get_tree().current_scene.add_child(bullet)

func Enter() -> void:
	if enemy.line_of_sight(enemy.cast_point.global_position, enemy.nav.target_position):
		shoot()
		if animation:
			enemy.animations.play(animation)
	else:
		Transitioned.emit(self, next_state)
	
func Update(_delta: float) -> void:
	if enemy.animations.frame == final_frame:
		Transitioned.emit(self, next_state)
