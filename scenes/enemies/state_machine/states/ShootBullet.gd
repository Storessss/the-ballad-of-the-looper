extends State

class_name ShootBullet

@onready var enemy: Enemy = get_parent().get_parent()
@export var bullet_scene: PackedScene
@export var bullet_count: int = 1
@export var bullet_spread: int = 5
@export var auto_target_player_before_shooting: bool
@export var animation: String
@export var sound: String
@export var final_frame: int
@export var shoot_immediately: bool
@export var next_state: State
@export_category("Optional Randomness")
@export var random_shoot_direction: bool
@export var unified_direction: bool = true
var random_unified_angle: float
@export_category("Spawn on Child Nodes")
@export var child_spawner: Node2D

func shoot() -> void:
	var pos = round(-bullet_spread * (bullet_count / 2))
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		var point = GlobalVariables.player_position - enemy.cast_point.global_position
		bullet.angle = point.angle() + deg_to_rad(pos)
		if random_shoot_direction:
			if unified_direction:
				bullet.angle = random_unified_angle + deg_to_rad(pos)
			else:
				bullet.angle = randf() * TAU + deg_to_rad(pos)
		if child_spawner:
			for spawner: Node2D in child_spawner.spawners:
				var spawner_bullet: CharacterBody2D = bullet.duplicate()
				spawner_bullet.global_position = spawner.global_position
				spawner_bullet.angle = (spawner.global_position - spawner.get_parent().global_position).angle()
				get_tree().current_scene.add_child(spawner_bullet)
		else:
			bullet.global_position = enemy.cast_point.global_position
			get_tree().current_scene.add_child(bullet)
		pos += bullet_spread
	if sound:
		MusicPlayer.call(sound)

func Enter() -> void:
	await get_tree().process_frame
	
	if random_shoot_direction and unified_direction:
		random_unified_angle = randf() * TAU
		
	if shoot_immediately:
		shoot()
		Transitioned.emit(self, next_state)
		
	if auto_target_player_before_shooting:
		enemy.nav.target_position = GlobalVariables.player_position
	if enemy.line_of_sight(enemy.cast_point.global_position, enemy.nav.target_position):
		shoot()
		if animation:
			enemy.animations.play(animation)
		else:
			Transitioned.emit(self, next_state)
	else:
		Transitioned.emit(self, next_state)
	
func Update(_delta: float) -> void:
	if enemy.animations.frame == final_frame:
		Transitioned.emit(self, next_state)
