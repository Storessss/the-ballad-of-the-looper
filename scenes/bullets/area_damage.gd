extends Area2D

class_name AreaDamage

@export var radius: float = 1.0
var damage: int
var destroy_time: float = 0.5
@export var explosion: bool = true
@export var destructive: bool = true
@export var damages_player: bool = true
@export var damages_enemies: bool = true
@export var damage_time: float
@export var particle_scene: PackedScene
@export var explosion_sound: String

var in_area: Array[CharacterBody2D]

func _ready() -> void:
	$CollisionShape2D.shape.radius = 15.0
	$CollisionShape2D.shape.radius = ($CollisionShape2D.shape.radius * radius) + $CollisionShape2D.shape.radius
	
	$DamageTimer.start(damage_time)
	$DestroyTimer.start(destroy_time)
	
	if destructive:
		break_walls()
		
	if particle_scene:
		if explosion:
			var particles = particle_scene.instantiate()
			particles.global_position = global_position
			particles.radius = radius
			get_tree().current_scene.add_child(particles)
			if explosion_sound:
				MusicPlayer.call(explosion_sound)
		else:
			var particles = particle_scene.instantiate()
			particles.radius = radius
			add_child(particles)
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if damages_enemies:
			if not explosion:
				if body not in in_area:
					in_area.append(body)
			else:
				body.take_damage(damage)
	elif body.is_in_group("players"):
		if damages_player:
			if not explosion:
				if body not in in_area:
					in_area.append(body)
			else:
				body.take_damage()
			
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if not explosion:
			if body in in_area:
				in_area.erase(body)
	elif body.is_in_group("players"):
		if not explosion:
			if body in in_area:
				in_area.erase(body)
				
func _on_damage_timer_timeout() -> void:
	for body in in_area:
		if body.is_in_group("enemies"):
			body.take_damage(damage)
		elif body.is_in_group("players"):
			body.take_damage()
			
func break_walls():
	var area: Array[int]
	var area_counter: int = -radius
	while area_counter <= radius:
		area.append(area_counter)
		area_counter += 1
	var cell: Vector2i = GlobalVariables.tilemap.local_to_map(GlobalVariables.tilemap.to_local(global_position))
	for i in area:
		for j in area:
			GlobalVariables.tilemap.set_floor_at_runtime(Vector2i(cell.x + i, cell.y + j))

func _on_destroy_timer_timeout() -> void:
	queue_free()
