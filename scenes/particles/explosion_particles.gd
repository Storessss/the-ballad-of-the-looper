extends Node2D

var radius: int

func _ready():
	$Explosion.scale = ($Explosion.scale * radius) + $Explosion.scale
	$Explosion.scale_amount_min = ($Explosion.scale_amount_min * radius) + $Explosion.scale_amount_min
	$Explosion.emitting = true
