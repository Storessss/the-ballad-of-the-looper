extends State

class_name ShootSpawnerBullet

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var spawner: Node2D
@export var animation: String
@export var sound: String
@export var next_state: State

func shoot() -> void:
	for spawner: Node2D in spawner.spawners:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawner.global_position
		bullet.angle = (spawner.global_position - spawner.get_parent().global_position).angle()
		get_tree().current_scene.add_child(bullet)
	if sound:
		MusicPlayer.call(sound)

func Enter() -> void:
	await get_tree().process_frame
	
	if animation:
		enemy.animations.play(animation)
	
	shoot()
	Transitioned.emit(self, next_state)
