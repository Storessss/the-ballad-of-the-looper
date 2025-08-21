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
		GlobalVariables.inventory = starting_inventory.duplicate()
	
	instantiate_weapon()
	
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
	$Weapon.rotation = angle + PI / 2
	
	# INVENTORY ------------------------------------------------------------------------------------
	if Input.is_action_just_pressed("next_weapon"):
		GlobalVariables.previous_inventory_index = GlobalVariables.inventory_index
		GlobalVariables.inventory_index = ((GlobalVariables.inventory_index + 1) % \
		GlobalVariables.inventory.size() + GlobalVariables.inventory.size()) % GlobalVariables.inventory.size()
		instantiate_weapon()
	elif Input.is_action_just_pressed("previous_weapon"):
		GlobalVariables.previous_inventory_index = GlobalVariables.inventory_index
		GlobalVariables.inventory_index = ((GlobalVariables.inventory_index - 1) % \
		GlobalVariables.inventory.size() + GlobalVariables.inventory.size()) % GlobalVariables.inventory.size()
		instantiate_weapon()
		
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
	
func take_damage():
	if $IFrames.is_stopped():
		GlobalVariables.player_health -= 1
		$IFrames.start()
		$HitSound.play()
		GlobalVariables.player_hit.emit()
		
func instantiate_weapon():
	for child: Weapon in $Weapon/Point.get_children():
		GlobalVariables.weapon_states[GlobalVariables.previous_inventory_index] = {
			"previous_reload_time": child.previous_reload_time
		}
		child.queue_free()
	var weapon: Weapon = GlobalVariables.inventory[GlobalVariables.inventory_index].instantiate()
	if GlobalVariables.weapon_states.has(GlobalVariables.inventory_index):
		weapon.previous_reload_time = \
		GlobalVariables.weapon_states[GlobalVariables.inventory_index].get("previous_reload_time", 0.0)
	else:
		weapon.previous_reload_time = 0.0
	$Weapon/Point.add_child(weapon)
	
func _on_dialogue_show(_character_name: String, _image: Texture, _text: String, _choices: Array, \
_font: FontFile):
	movement_enabled = false
	
func _on_dialogue_hide():
	movement_enabled = true
