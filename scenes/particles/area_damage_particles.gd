extends Node2D

var radius: int

func _ready():
	$Particles.scale = ($Particles.scale * radius) + $Particles.scale
	$Particles.scale_amount_min = ($Particles.scale_amount_min * radius) + $Particles.scale_amount_min
	$Particles.emitting = true
