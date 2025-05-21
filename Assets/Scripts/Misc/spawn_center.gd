extends Marker2D

@onready var SpawnPoint = $SpawnPoint
@onready var Enemy = preload("res://Assets/Scenes/Entities/Stars/enemybasic.tscn")
var spawnRate = 30
var spawnTimer = 0

func _physics_process(delta: float) -> void:
	spawnTimer += 1
	if(spawnTimer > spawnRate * 60):
		global_rotation_degrees = randf_range(0,360)
		spawnTimer = 0
		var enemy = Enemy.instantiate()
		enemy.global_position = SpawnPoint.global_position
		get_parent().get_parent().add_child(enemy)
