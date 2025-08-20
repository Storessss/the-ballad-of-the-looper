extends CharacterBody2D

class_name Bullet

@export var speed: int
@export var destroy_time: float
@export var bouncing: bool
@export var transparent: bool
@export var deflectable: bool = true
@export var pierce: int = 1
@export var destructive: bool
@export var explosive: bool
@export var explosion_radius: int
var area_damage_scene = preload("res://scenes/bullets/area_damage.tscn")
var explosion_particles_scene = preload("res://scenes/particles/explosion_particles.tscn")

var angle: float
var damage: int
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
	
func _process(_delta: float) -> void:
	direction = Vector2(cos(angle), sin(angle))
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
				
	if destructive:
		var cell: Vector2i = GlobalVariables.tilemap.local_to_map(GlobalVariables.tilemap.to_local(global_position))
		var hit_wall: bool = GlobalVariables.tilemap.set_floor(cell)
		if hit_wall:
			pierce -= 1
			if pierce <= 0:
				queue_free()
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("players"):
		if explosive:
			explode(explosion_radius)
			
	if body.is_in_group("enemies") and player_bullet:
		body.take_damage(damage)
		pierce -= 1
		if pierce <= 0:
			queue_free()
	elif body.is_in_group("players") and not player_bullet:
		if not GlobalVariables.dashing and not GlobalVariables.graced:
			body.take_damage()
			queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		if not bouncing and not transparent:
			queue_free()
	elif body.is_in_group("bullets") and deflective:
		if body.player_bullet != player_bullet:
			if body.deflectable:
				body.angle = angle
				#body.angle -= PI
				body.damage = damage / 4
				body.speed *= 2
				MusicPlayer.bullet_deflect()
				body.change_alignment()

func _on_destroy_timer_timeout() -> void:
	if explosive:
		explode(explosion_radius)
	queue_free()

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
		
func explode(radius: int):
	if destructive:
		var area: Array[int]
		var area_counter: int = -radius
		while area_counter <= radius:
			area.append(area_counter)
			area_counter += 1
		var cell: Vector2i = GlobalVariables.tilemap.local_to_map(GlobalVariables.tilemap.to_local(global_position))
		for i in area:
			for j in area:
				GlobalVariables.tilemap.set_floor(Vector2i(cell.x + i, cell.y + j))
		var area_damage: Area2D = area_damage_scene.instantiate()
		area_damage.global_position = global_position
		area_damage.radius = radius
		area_damage.damage = damage * 2
		get_tree().current_scene.call_deferred("add_child", area_damage)
		var particles = explosion_particles_scene.instantiate()
		particles.global_position = global_position
		particles.radius = radius
		get_tree().current_scene.add_child(particles)
		MusicPlayer.explosion_sound()
		queue_free()
