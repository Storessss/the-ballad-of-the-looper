extends Node2D

class_name Weapon

@export var fire_rate: float
@export var damage: int
@export var effect_damage: int
@export var bullet_count: int = 1
@export var bullet_spread: int = 5
@export var bullet_scene: PackedScene
@export var deflective_shots: bool
@export var full_durability: int = 1000000000
@export var automatic: bool = true
@export var break_sound: String = "weapon_break"
var durability: int

var reticle_position: Vector2
var weapon_point: Node2D

var previous_reload_time: float

func _ready():
	$FireRateTimer.start(previous_reload_time)
	if previous_reload_time == 0.0:
		$FireRateTimer.stop()

func shoot() -> void:
	$FireRateTimer.start(fire_rate)
	var pos = round(-bullet_spread * (bullet_count / 2))
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		var point
		if GlobalVariables.controller:
			point = global_position - GlobalVariables.player_position
		else:
			point = get_global_mouse_position() - global_position
		bullet.angle = point.angle() + deg_to_rad(pos)
		bullet.global_position = $CastPoint.global_position
		pos += bullet_spread
		bullet.damage = damage
		bullet.effect_damage = effect_damage
		bullet.player_bullet = true
		bullet.deflective = deflective_shots
		get_tree().current_scene.add_child(bullet)
		if self is not ChargedWeapon:
			$AttackSound.play()
	durability -= 1
	GlobalVariables.weapon_states[GlobalVariables.inventory_index]["durability"] = durability
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack") and $FireRateTimer.is_stopped() and automatic:
		shoot()
	elif Input.is_action_just_pressed("attack") and $FireRateTimer.is_stopped() and not automatic:
		shoot()
	previous_reload_time = $FireRateTimer.time_left
	
	weapon_durability_manager()
	
func weapon_durability_manager() -> void:
	GlobalVariables.weapon_full_durability = full_durability
	GlobalVariables.weapon_durability = durability
	if durability <= 0:
		if break_sound:
			MusicPlayer.call(break_sound)
		GlobalVariables.remove_from_inventory(self)
	
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
