extends CharacterBody2D

var speed: int = 200
var direction: Vector2

var dash_angle: Vector2
var dash_speed: int = 1000

var deadzone: float = 0.1

@export var inventory: Array[PackedScene]

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	InputMap.action_set_deadzone("look_up", deadzone)
	InputMap.action_set_deadzone("look_down", deadzone)
	InputMap.action_set_deadzone("look_left", deadzone)
	InputMap.action_set_deadzone("look_right", deadzone)
	
	instantiate_weapon()
	
func _process(_delta: float) -> void:
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
		GlobalVariables.inventory_index = ((GlobalVariables.inventory_index + 1) % inventory.size() \
		+ inventory.size()) % inventory.size()
		instantiate_weapon()
	
func take_damage():
	if $IFrames.is_stopped():
		GlobalVariables.player_health -= 1
		$IFrames.start()
		
func instantiate_weapon():
	for child in $Weapon/Point.get_children():
		child.queue_free()
	var weapon = inventory[GlobalVariables.inventory_index].instantiate()
	$Weapon/Point.add_child(weapon)
