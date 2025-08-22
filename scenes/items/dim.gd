extends Node2D

var direction: Vector2
var speed: int = 300
var delay: bool

func _ready() -> void:
	if delay:
		$WaitTimer.wait_time = randf_range(0.1, 1.5) + 3.0
	else:
		$WaitTimer.wait_time = randf_range(0.1, 1.5)
	$WaitTimer.start()

func _process(delta: float) -> void:
	if $WaitTimer.is_stopped():
		direction = (GlobalVariables.player_position - global_position).normalized()
		position += direction * speed * delta

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("players"):
		GlobalVariables.dims += 1
		MusicPlayer.dim_get()
		queue_free()
