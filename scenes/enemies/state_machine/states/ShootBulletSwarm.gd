extends State

class_name ShootBulletSwarm

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var area: Vector2
@export var bullet_count: int = 10
@export var animation: String
@export var sound: String
@export var final_frame: int
@export var next_state: State

func shoot() -> void:
	for i in range(bullet_count):
		await get_tree().create_timer(0.05).timeout
		var bullet: CharacterBody2D = bullet_scene.instantiate()
		bullet.angle = (GlobalVariables.player_position - enemy.global_position).angle()
		bullet.global_position.x = randf_range(
			enemy.global_position.x - area.x / 2,
			enemy.global_position.x + area.x / 2
			)
		bullet.global_position.y = randf_range(
			enemy.global_position.y - area.y / 2,
			enemy.global_position.y + area.y / 2
			)
		get_tree().current_scene.add_child(bullet)
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
