extends Weapon

class_name ChargedWeapon

@export var charge_time: float
var charging: bool
var is_fully_charged: bool
var pending_attack: bool

func _ready() -> void:
	super._ready()
	$ChargeTimer.wait_time = charge_time

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		$ChargeTimer.start()
		charging = true
		is_fully_charged = false

	if Input.is_action_just_released("attack") and charging:
		charging = false
		is_fully_charged = $ChargeTimer.is_stopped()
		pending_attack = true

	if pending_attack and $FireRateTimer.is_stopped():
		pending_attack = false
		if is_fully_charged:
			deflective_shots = true
			damage *= 2
			shoot()
			deflective_shots = false
			damage /= 2
		else:
			shoot()
				
	if charging and $ChargeTimer.is_stopped():
		modulate = Color.BLUE
	else:
		modulate = Color.WHITE
