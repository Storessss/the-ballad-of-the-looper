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
@export var area_damage_scene: PackedScene
@export var knockback_amount: int

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
	if body.is_in_group("enemies") and player_bullet:
		body.take_damage(damage)
		body.apply_knockback(direction * knockback_amount)
		pierce -= 1
		if pierce <= 0:
			queue_free()
	elif body.is_in_group("players") and not player_bullet:
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
				body.damage = effect_damage
				body.speed *= 2
				MusicPlayer.bullet_deflect()
				body.change_alignment()
				
	if not body.is_in_group("players") and not body.is_in_group("bullets"):
		if area_damage_scene and explosive:
			explode()

func _on_destroy_timer_timeout() -> void:
	if area_damage_scene and explosive:
		explode()
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
		
func explode():
	var area_damage = area_damage_scene.instantiate()
	area_damage.global_position = global_position
	area_damage.damage = effect_damage
	get_tree().current_scene.call_deferred("add_child", area_damage)
	MusicPlayer.explosion_sound()
