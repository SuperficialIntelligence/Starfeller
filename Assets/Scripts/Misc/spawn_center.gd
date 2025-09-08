extends Marker2D

@onready var SpawnPoint = $SpawnPoint
@onready var EnemyBasic = preload("res://Assets/Scenes/Entities/Stars/enemybasic.tscn")
@onready var EnemyY= preload("res://Assets/Scenes/Entities/Stars/enemyY.tscn")
var spawnRate = 5
var spawnTimer = 0
var spawnTimer2 = 0

func _physics_process(delta: float) -> void:
	spawnTimer += 1
	if(spawnTimer > spawnRate * 60 and get_tree().get_nodes_in_group("EliteEnemy").size() <= 5):
		global_rotation_degrees = randf_range(0,360)
		spawnTimer = 0
		var enemy = EnemyBasic.instantiate()
		enemy.global_position = SpawnPoint.global_position
		get_parent().get_parent().add_child(enemy)
	
	#spawnTimer2 += 1
	#if(spawnTimer2 > spawnRate * 60 and get_tree().get_nodes_in_group("Enemy").size() <= 10):
		#global_rotation_degrees = randf_range(0,360)
		#spawnTimer = 0
		#var enemy = EnemyY.instantiate()
		#enemy.global_position = SpawnPoint.global_position
		#get_parent().get_parent().add_child(enemy)
