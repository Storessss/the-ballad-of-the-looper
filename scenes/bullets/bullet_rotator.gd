extends Node2D

@export var spawner_count: int
@export var spawner_distance: int
@export var spawner_rotation_speed: float

var spawners: Array[Node2D]

func _ready() -> void:
	for i in range(spawner_count):
		var spawner: Node2D = Node2D.new()
		var angle: float = (i * 360 / spawner_count)
		spawner.position = Vector2.from_angle(deg_to_rad(angle)) * spawner_distance
		add_child(spawner)
		spawners.append(spawner)
		
func _process(delta: float) -> void:
	global_rotation += delta * spawner_rotation_speed
