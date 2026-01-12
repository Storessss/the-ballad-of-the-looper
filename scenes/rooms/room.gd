extends Node2D

class_name Room

@onready var tilemap: TileMapLayer = $Tilemap
@export var music: AudioStream = preload("res://music/Safe Place.ogg")

func _ready() -> void:
	GlobalVariables.tilemap = tilemap
	#GlobalVariables.right = 426
	#GlobalVariables.bottom = 240
	for cell in tilemap.get_used_cells():
		GlobalVariables.tilemap.map.append(cell)
	$Player.remove_child($Player.camera)
	MusicPlayer.change_music(music)
	GlobalVariables.shake_camera.connect(Callable(self, "_on_camera_shake"))

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	$Camera2D.offset = randomOffset()

var random_strength = 30.0
var shake_fade = 5.0
var rnd = RandomNumberGenerator.new()
var shake_strength = 0.0
func _on_camera_shake(random_strength: float, shake_fade: float) -> void:
	self.random_strength = random_strength
	self.shake_fade = shake_fade
	apply_shake()
func apply_shake() -> void:
	shake_strength = random_strength
func randomOffset() -> Vector2:
	return Vector2(rnd.randf_range(- shake_strength, shake_strength), randf_range(- shake_strength, shake_strength))
