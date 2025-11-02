extends CanvasLayer

var heart_size: Vector2 = Vector2(50, 50)

func _ready() -> void:
	GlobalVariables.player_health_changed.connect(Callable(self, "_on_player_health_changed"))
	update_health()

func update_health() -> void:
	for heart in $HealthBar.get_children():
		heart.queue_free()
	for i in range(GlobalVariables.player_health / 2):
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_full.png")
		$HealthBar.add_child(heart)
	if (GlobalVariables.player_health % 2) != 0:
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_half.png")
		$HealthBar.add_child(heart)
	for i in range((GlobalVariables.player_max_health / 2) - ceil(GlobalVariables.player_health / 2.0)):
		var heart: TextureRect = TextureRect.new()
		heart.custom_minimum_size = heart_size
		heart.texture = preload("res://sprites/heart_empty.png")
		$HealthBar.add_child(heart)

func _on_player_health_changed() -> void:
	GlobalVariables.player_health = min(GlobalVariables.player_health, GlobalVariables.player_max_health)
	update_health()
	

func _process(_delta: float) -> void:
	$Dims/DimCount.text = str(GlobalVariables.dims)
	
	if GlobalVariables.weapon_full_durability:
		$WeaponDurability.value = GlobalVariables.weapon_durability * 100 / GlobalVariables.weapon_full_durability
