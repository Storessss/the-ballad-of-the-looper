extends CharacterBody2D

class_name Bullet

@export var speed: int
@export var destroy_time: float
@export var bouncing: bool
@export var transparent: bool
@export var deflectable: bool = true

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
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and player_bullet:
		body.take_damage(damage)
		queue_free()
	elif body.is_in_group("players") and not player_bullet:
		if not GlobalVariables.dashing and not GlobalVariables.graced:
			body.take_damage()
			queue_free()
	elif body is TileMapLayer:
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
