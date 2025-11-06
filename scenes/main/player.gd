extends CharacterBody2D

var speed: int = 200
var direction: Vector2

var dash_angle: Vector2
var dash_speed: int = 1000

var deadzone: float = 0.1

@export var starting_inventory: Array[PackedScene]

@onready var camera: Camera2D = $Camera2D
var shake = false
var random_strength = 30.0
var shake_fade = 5.0
var rnd = RandomNumberGenerator.new()
var shake_strength = 0.0

var movement_enabled: bool = true

func _ready() -> void:
	InputMap.action_set_deadzone("look_up", deadzone)
	InputMap.action_set_deadzone("look_down", deadzone)
	InputMap.action_set_deadzone("look_left", deadzone)
	InputMap.action_set_deadzone("look_right", deadzone)
	
	if GlobalVariables.first_time_inventory_instantiation:
		GlobalVariables.first_time_inventory_instantiation = false
		for item_scene in starting_inventory:
			GlobalVariables.append_to_inventory(item_scene)
	
	instantiate_item()
	
	DialogueManager.show_dialogue.connect(Callable(self, "_on_dialogue_show"))
	DialogueManager.hide_dialogue.connect(Callable(self, "_on_dialogue_hide"))
	
func _process(delta: float) -> void:
	if movement_enabled:
		direction = Input.get_vector("left", "right", "up", "down")
		move_and_slide()
	
	# DASH -----------------------------------------------------------------------------------------
	if $Dash/DashTimer.is_stopped() and GlobalVariables.dashing:
		$Dash/DashCooldown.start()
		$Dash/GraceTimer.start()
		GlobalVariables.graced = true
	if $Dash/DashTimer.is_stopped():
		velocity = direction * speed
		GlobalVariables.dashing = false
	else:
		velocity = dash_angle * dash_speed
		
	if $Dash/DashCooldown.is_stopped() and $Dash/DashTimer.is_stopped():
		$AnimatedSprite2D.modulate = Color.WHITE
	if Input.is_action_just_pressed("dash") and $Dash/DashCooldown.is_stopped() and direction != Vector2.ZERO:
		$Dash/DashSound.play()
		dash_angle = direction
		GlobalVariables.dashing = true
		$Dash/DashTimer.start()
		$AnimatedSprite2D.modulate = Color.DIM_GRAY
	if $Dash/GraceTimer.is_stopped():
		GlobalVariables.graced = false
		
	# ANIMATIONS -----------------------------------------------------------------------------------
	if not $IFrames.is_stopped():
		$AnimatedSprite2D.play("hit")
	else:
		if direction!= Vector2(0,0):
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	# AIM ------------------------------------------------------------------------------------------
	var look_vector = Vector2.ZERO
	var point
	var angle
	if GlobalVariables.controller:
		look_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		look_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		$Reticle.global_position = (position + look_vector * 50)
		point = $Reticle.global_position - global_position
		angle = point.angle()
	else:
		point = get_global_mouse_position() - global_position
		angle = point.angle()
	if look_vector == Vector2.ZERO:
		$Reticle.visible = false
	else:
		$Reticle.visible = true
	$Item.rotation = angle + PI / 2
	
	# INVENTORY ------------------------------------------------------------------------------------
	if Input.is_action_just_pressed("next_item"):
		GlobalVariables.previous_inventory_index = GlobalVariables.inventory_index
		GlobalVariables.inventory_index = ((GlobalVariables.inventory_index + 1 + GlobalVariables.inventory_index_rounder) % \
		GlobalVariables.inventory.size() + GlobalVariables.inventory.size()) % GlobalVariables.inventory.size()
		GlobalVariables.inventory_index_rounder = 0
		instantiate_item()
		show_hotbar()
	elif Input.is_action_just_pressed("previous_item"):
		GlobalVariables.previous_inventory_index = GlobalVariables.inventory_index
		GlobalVariables.inventory_index = ((GlobalVariables.inventory_index - 1) % \
		GlobalVariables.inventory.size() + GlobalVariables.inventory.size()) % GlobalVariables.inventory.size()
		GlobalVariables.inventory_index_rounder = 0
		instantiate_item()
		show_hotbar()
		
	# CAMERA ---------------------------------------------------------------------------------------
	camera.limit_right = GlobalVariables.right
	camera.limit_bottom = GlobalVariables.bottom
	
	if shake:
		apply_shake()
		shake = false
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
	camera.offset = randomOffset()
		
func apply_shake():
	shake_strength = random_strength
func randomOffset():
	return Vector2(rnd.randf_range(- shake_strength, shake_strength), randf_range(- shake_strength, shake_strength))
	
func take_damage(damage: int = 1) -> bool:
	if $IFrames.is_stopped() and not GlobalVariables.dashing and not GlobalVariables.graced:
		GlobalVariables.player_health -= damage
		$IFrames.start()
		$HitSound.play()
		GlobalVariables.player_health_changed.emit()
		return true
	return false
		
func instantiate_item():
	for child: Node2D in $Item/Point.get_children():
		if child is Weapon:
			GlobalVariables.weapon_states[GlobalVariables.previous_inventory_index]\
			["reload_time"] = child.previous_reload_time
		child.queue_free()
	if GlobalVariables.inventory_index >= GlobalVariables.inventory.size():
		GlobalVariables.inventory_index = 0
	var item: Node2D = GlobalVariables.inventory[GlobalVariables.inventory_index].instantiate()
	if item is Weapon:
		item.previous_reload_time = \
		GlobalVariables.weapon_states[GlobalVariables.inventory_index]["reload_time"]
		item.durability = \
		GlobalVariables.weapon_states[GlobalVariables.inventory_index]["durability"]
	$Item/Point.add_child(item)

func show_hotbar() -> void:
	$HotbarTimer.start()
	$Hotbar.visible = true
	Engine.time_scale = 0.4
	for i in [-1, 0, 1]:
		var index: int = ((GlobalVariables.inventory_index + i + GlobalVariables.inventory_index_rounder) % \
		GlobalVariables.inventory.size() + GlobalVariables.inventory.size()) % GlobalVariables.inventory.size()
		var item: Node2D = GlobalVariables.inventory[index].instantiate()
		var sprite: Sprite2D = item.get_node("Sprite2D")
		var texture: Texture = sprite.texture
		$Hotbar.get_child(i + 1).texture = texture

func _on_hotbar_timer_timeout() -> void:
	$Hotbar.visible = false
	Engine.time_scale = 1.0
