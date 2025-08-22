extends Node2D

class_name Weapon

@export var fire_rate: float
@export var damage: int
@export var effect_damage: int
@export var bullet_scene: PackedScene
@export var deflective_shots: bool
#@export var melee: bool

var reticle_position: Vector2
var weapon_point: Node2D

var previous_reload_time: float

func _ready():
	$FireRateTimer.start(previous_reload_time)
	if previous_reload_time == 0.0:
		$FireRateTimer.stop()

func shoot() -> void:
	$FireRateTimer.start(fire_rate / GlobalVariables.fire_rate_multiplier)
	#if line_of_sight(GlobalVariables.player_position, $CastPoint.global_position) or melee:
	var bullet = bullet_scene.instantiate()
	var point
	if GlobalVariables.controller:
		point = $CastPoint.global_position - GlobalVariables.player_position
	else:
		point = get_global_mouse_position() - global_position
	bullet.angle = point.angle()
	bullet.global_position = GlobalVariables.player_position
	bullet.damage = max(damage * GlobalVariables.damage_multiplier, 1)
	bullet.effect_damage = max(effect_damage * GlobalVariables.damage_multiplier, 1)
	bullet.player_bullet = true
	bullet.deflective = deflective_shots
	get_tree().current_scene.add_child(bullet)
	if self is not ChargedWeapon:
		$AttackSound.play()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack") and $FireRateTimer.is_stopped():
		shoot()
	previous_reload_time = $FireRateTimer.time_left
	
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
