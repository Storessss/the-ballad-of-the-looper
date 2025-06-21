extends State

class_name ShootBullet

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var bullet_count: int = 1
@export var bullet_spread: int = 5
@export var animation: String
@export var final_frame: int
@export var next_state: State

func shoot() -> void:
	var pos = round(-bullet_spread * (bullet_count / 2))
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		var point = GlobalVariables.player_position - enemy.cast_point.global_position
		bullet.angle = point.angle() + deg_to_rad(pos)
		bullet.position = Vector2(enemy.cast_point.global_position.x, enemy.cast_point.global_position.y)
		pos += bullet_spread
		get_tree().current_scene.add_child(bullet)
			
func Enter() -> void:
	await get_tree().process_frame
	if enemy.line_of_sight(enemy.cast_point.global_position, enemy.nav.target_position):
		shoot()
		if animation:
			enemy.animations.play(animation)
	else:
		Transitioned.emit(self, next_state)
	
func Update(_delta: float) -> void:
	if enemy.animations.frame == final_frame:
		Transitioned.emit(self, next_state)
