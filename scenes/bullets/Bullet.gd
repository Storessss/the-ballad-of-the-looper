extends CharacterBody2D

class_name Bullet

@export var speed: int
@export var destroy_time: float
@export var bouncing: bool
@export var transparent: bool
@export var deflectable: bool = true
@export var bonus_deflect_damage: int
@export var back_to_sender_deflect: bool
@export var pierce: int = 1
@export var destructive: bool
@export var explosive: bool
@export var area_damage_scene: PackedScene
@export var homing: bool
@export var bullet_ring_count: int
@export var bullet_ring_scene: PackedScene
@export var destroy_sound: String
@export var bounce_sound: String

var angle: float
var damage: int
var effect_damage: int
var player_bullet: bool
var deflective: bool
var deflected: bool

var direction: Vector2

func _ready() -> void:
	$DestroyTimer.wait_time = destroy_time
	$DestroyTimer.start()
	
	if transparent:
		$CollisionShape2D.disabled = true
		
	var shader_material : ShaderMaterial = ShaderMaterial.new()
	
	if player_bullet:
		shader_material.shader = preload("res://styles/outline_blue.gdshader")
	else:
		shader_material.shader = preload("res://styles/outline_red.gdshader")
		
	$Sprite2D.material = shader_material
	
	if area_damage_scene and not explosive:
		var area_damage = area_damage_scene.instantiate()
		area_damage.damage = effect_damage
		area_damage.destroy_time = destroy_time
		add_child(area_damage)
	
func _process(delta: float) -> void:
	direction = Vector2(cos(angle), sin(angle))
	if homing and player_bullet and get_tree().get_nodes_in_group("enemies"):
		var closest_distance: float = INF
		var closest_enemy: Enemy
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var distance: float = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
				
		direction = (closest_enemy.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	rotation = direction.angle() + PI / 2
	
	if bouncing:
		for i in range (get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var normal = collision.get_normal()
			if $BounceTimer.is_stopped():
				if abs(normal.x) > abs(normal.y):
					angle = PI - angle
				else:
					angle = -angle
				$BounceTimer.start()
				if bounce_sound:
					MusicPlayer.call(bounce_sound)
				
	if destructive:
		#transparent = true
		var cell: Vector2i = GlobalVariables.tilemap.local_to_map(GlobalVariables.tilemap.to_local(global_position))
		var hit_wall: bool = GlobalVariables.tilemap.set_floor_at_runtime(cell)
		if hit_wall:
			pierce -= 1
			if pierce <= 0:
				destroy()
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and player_bullet:
		body.take_damage(damage)
		pierce -= 1
		if pierce <= 0:
			destroy()
	elif body.is_in_group("players") and not player_bullet:
		var player_damaged: bool = body.take_damage()
		if player_damaged:
			#queue_free()
			destroy()
	elif body is TileMapLayer or body is StaticBody2D:
		if not bouncing and not transparent:
			#queue_free()
			destroy()
	elif body.is_in_group("bullets") and deflective:
		if body.player_bullet != player_bullet:
			if body.deflectable:
				if body.back_to_sender_deflect:
					body.angle -= PI
				else:
					body.angle = angle
				body.damage = effect_damage + body.bonus_deflect_damage
				body.speed *= 2
				MusicPlayer.bullet_deflect()
				body.change_alignment()
				
	if not body.is_in_group("players") and not body.is_in_group("bullets"):
		if area_damage_scene and explosive:
			explode()

func _on_destroy_timer_timeout() -> void:
	#if area_damage_scene and explosive:
		#explode()
	#queue_free()
	destroy()

func change_alignment() -> void:
	if not deflected:
		deflected = true
		player_bullet = not player_bullet
		var shader_material : ShaderMaterial = ShaderMaterial.new()
		if player_bullet:
			shader_material.shader = preload("res://styles/outline_blue.gdshader")
		else:
			shader_material.shader = preload("res://styles/outline_red.gdshader")
		$Sprite2D.material = shader_material
		
func explode():
	var area_damage = area_damage_scene.instantiate()
	area_damage.global_position = global_position
	area_damage.damage = effect_damage
	get_tree().current_scene.call_deferred("add_child", area_damage)
	
func bullet_ring():
	for i in range(bullet_ring_count):
		var angle = deg_to_rad(i * 360 / bullet_ring_count)
		var bullet = bullet_ring_scene.instantiate()
		bullet.angle = angle
		bullet.global_position = global_position
		bullet.player_bullet = player_bullet
		bullet.damage = effect_damage
		get_tree().current_scene.add_child(bullet)

func destroy() -> void:
	if area_damage_scene and explosive:
		explode()
	if bullet_ring_count > 0 and bullet_ring_scene:
		call_deferred("bullet_ring")
	if destroy_sound:
		MusicPlayer.call(destroy_sound)
	queue_free()
