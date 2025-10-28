extends Node2D

class_name Potion

@export var drink_time: float
@export var uses: int = 1

var drinking: bool

func _ready() -> void:
	$DrinkTimer.wait_time = drink_time

func effect() -> void:
	uses -= 1

func drink() -> void:
	if Input.is_action_just_released("attack"):
		drinking = false
		$DrinkSound.stop()
	if $DrinkTimer.is_stopped() and drinking:
		MusicPlayer.potion_drink_finished()
		effect()
		if uses <= 0:
			GlobalVariables.remove_from_inventory(self)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		drinking = true
		$DrinkTimer.start()
		$DrinkSound.play()
	drink()
	GlobalVariables.weapon_full_durability = $DrinkTimer.wait_time * 100
	if drinking:
		GlobalVariables.weapon_durability = $DrinkTimer.time_left * 100
	else:
		GlobalVariables.weapon_durability = $DrinkTimer.wait_time * 100
