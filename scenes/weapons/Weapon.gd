extends Node2D

class_name Weapon

@export var fire_rate: float
@export var damage: int
@export var bullet_scene: PackedScene
@export var deflective_shots: bool

var reticle_position: Vector2
var weapon_point: Node2D

func _ready():
	$FireRateTimer.wait_time = fire_rate

func shoot() -> void:
	$FireRateTimer.start()
	if line_of_sight(GlobalVariables.player_position, $CastPoint.global_position):
			var bullet = bullet_scene.instantiate()
			var point
			if GlobalVariables.controller:
				point = $CastPoint.global_position - GlobalVariables.player_position
			else:
				point = get_global_mouse_position() - global_position
			bullet.angle = point.angle()
			bullet.global_position = $CastPoint.global_position
			bullet.damage = damage
			bullet.player_bullet = true
			bullet.deflective = deflective_shots
			get_tree().current_scene.add_child(bullet)
	
func line_of_sight(from: Vector2, to: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.new()
	params.from = from
	params.to = to
	params.exclude = []
	params.collision_mask = 1
	var result = space_state.intersect_ray(params)
	if result:
		return false
	return true
