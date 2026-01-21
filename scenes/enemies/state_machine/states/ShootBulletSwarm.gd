extends State

class_name ShootBulletSwarm

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var area: Vector2
@export var bullet_count: int = 10
@export var bullet_spawn_delay: float
@export var unified_diection: bool
@export var animation: String
@export var sound: String
@export var final_frame: int
@export var next_state: State
var bullets: Array[Bullet]
var added_destroy_time: float
var bullet_speed: int

func shoot() -> void:
	added_destroy_time = bullet_count * bullet_spawn_delay
	for i in range(bullet_count):
		await get_tree().create_timer(bullet_spawn_delay).timeout
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.angle = (GlobalVariables.player_position - enemy.global_position).angle()
		bullet.global_position.x = randf_range(
			enemy.global_position.x - area.x / 2,
			enemy.global_position.x + area.x / 2
			)
		bullet.global_position.y = randf_range(
			enemy.global_position.y - area.y / 2,
			enemy.global_position.y + area.y / 2
			)
		bullet_speed = bullet.speed
		bullet.destroy_time += added_destroy_time
		bullet.speed = 0
		bullets.append(bullet)
		get_tree().current_scene.add_child(bullet)
	for bullet: Bullet in bullets:
		if bullet:
			bullet.speed = bullet_speed
			if unified_diection:
				bullet.angle = (GlobalVariables.player_position - enemy.global_position).angle()
	bullets.clear()
	if sound:
		MusicPlayer.call(sound)

func Enter() -> void:
	await get_tree().process_frame
	
	shoot()
	
	if animation:
		enemy.animations.play(animation)
	else:
		Transitioned.emit(self, next_state)
	
func Update(_delta: float) -> void:
	if enemy.animations.frame == final_frame:
		Transitioned.emit(self, next_state)
