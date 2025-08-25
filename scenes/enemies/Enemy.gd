extends CharacterBody2D

class_name Enemy

@export var health: int
@export var speed: int
@export var contact_damage: bool
@export var nav_agent_movement: bool = true
@export var boss: bool
@export var min_dim_drop: int = 1
@export var max_dim_drop: int = 1
var dim_scene: PackedScene = preload("res://scenes/items/dim.tscn")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var cast_point: Node2D = $CastPoint
var direction: Vector2
var last_seen_position: Vector2

var can_die: bool = true
var death_particles_scene = preload("res://scenes/particles/death_particles.tscn")

var default_modulate: Color = Color.WHITE

func _ready() -> void:
	$ModulateTimer.connect("timeout", Callable(self, "_on_modulate_timer_timeout"))
	$Area2D.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
	nav.connect("velocity_computed", Callable(self, "_on_nav_velocity_computed"))
	
	modulate = default_modulate
	

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()
	modulate = Color(5,5,5,1)
	$ModulateTimer.start()
	MusicPlayer.enemy_hit()
		
func _on_modulate_timer_timeout() -> void:
	modulate = default_modulate
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("players") and contact_damage:
		body.take_damage()
	
func _process(_delta: float) -> void:
	if nav_agent_movement:
		var new_velocity = direction * speed
		nav.set_velocity(new_velocity)
	else:
		velocity = direction * speed
	
	move_and_slide()
	
	if velocity.x != 0:
		animations.flip_h = velocity.x < 0
		
	if line_of_sight(global_position, GlobalVariables.player_position):
		last_seen_position = GlobalVariables.player_position

func die() -> void:
	if can_die:
		can_die = false
		var dim_count = randi_range(min_dim_drop, max_dim_drop)
		for i in range(dim_count):
			var dim = dim_scene.instantiate()
			dim.global_position = global_position
			if boss:
				dim.delay = true
			get_tree().current_scene.call_deferred("add_child", dim)
		var particles = death_particles_scene.instantiate()
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
		if boss:
			MusicPlayer.boss_defeat()
			MusicPlayer.change_music(preload("res://music/Of Days Long Past.ogg"))
		else:
			MusicPlayer.enemy_defeat()
		queue_free()
	
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
	
#func line_of_bullet_sight(from: Vector2, to: Vector2) -> bool:
	#var space_state = get_world_2d().direct_space_state
	#var params = PhysicsShapeQueryParameters2D.new()
	#var shape = CircleShape2D.new()
	#shape.radius = 5
	#params.shape_rid = shape.get_rid()
	#params.transform = Transform2D(0, Vector2(global_position.x, global_position.y -30))
	#params.motion = to - from
	#params.collision_mask = 1
	#params.exclude = [self]
	#var result = space_state.intersect_shape(params)
	#if result.size() > 0:
		#return false
	#return true

func _on_nav_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
