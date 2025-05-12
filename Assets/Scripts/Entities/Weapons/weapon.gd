extends Node2D

@onready var Barrel = $WeaponPivot/Weapon/BarrelPivot/Barrel
@onready var BarrelPivot = $WeaponPivot/Weapon/BarrelPivot
@onready var WeaponPivot = $WeaponPivot
@onready var UseAnimationPlayer = $UseAnimationPlayer
@onready var Laser = preload("res://Assets/Scenes/Entities/Bullets/bullet.tscn")
@onready var Particles = preload("res://Assets/Scenes/Particles/particles.tscn")

@onready var weaponDictionary = WeaponsDictionary.WeaponsDictionary
@export var type = "UREB"

#Weapon Stats
var weaponType = "UREB"
var weaponReloadType = "Charge"

var bulletSpeed = 1000
var bulletDamage = 10

var baseRecoil = 100
var recoil = 0

var baseRotationSpeed = 0.3

var bulletAmount = 1

var firePerSec = 1
var reloadTime = 0.5

var spread = 0

#misc
var bulletType
var rotationSpeed = baseRotationSpeed
var bulletsLoaded = 0
var fireRateTimer = 0
var reloadTimer = 0
var flip = false

func _ready() -> void:
	initialize_stats()
	if(weaponType == "UREB"):
		bulletType = Laser
	else:
		bulletType = null
		
func initialize_stats():
	weaponType = weaponDictionary[type]["weaponType"]
	weaponReloadType = weaponDictionary[type]["weaponReloadType"]

	bulletSpeed = weaponDictionary[type]["bulletSpeed"]

	baseRecoil = weaponDictionary[type]["baseRecoil"]
	recoil = weaponDictionary[type]["recoil"]

	baseRotationSpeed = weaponDictionary[type]["baseRotationSpeed"]

	bulletAmount = weaponDictionary[type]["bulletAmount"]

	firePerSec = weaponDictionary[type]["firePerSec"]
	reloadTime = weaponDictionary[type]["reloadTime"]
	
	spread = weaponDictionary[type]["spread"]

func _physics_process(delta: float) -> void:
	if(weaponReloadType == "Charge"):
		pass
	else:
		reloadTimer += 1
	
	fireRateTimer += 1

func activate_left_click():
			
	recoil = 0
	if(bulletsLoaded > 0):
		if(fireRateTimer >= 60 * firePerSec):
			bulletsLoaded -= 1
			useLeft()
			recoil = baseRecoil
			fireRateTimer = 0
	
	if(bulletsLoaded < bulletAmount):
		if(weaponReloadType == "Charge" and bulletsLoaded <= 0):
			reloadTimer += 1
			if(reloadTimer < 10):
				var particles = Particles.instantiate()
				particles.position = BarrelPivot.position
				particles.emitting = true
				particles.radial_accel_min = -100 / (reloadTime / 3)
				particles.radial_accel_max = -100 / (reloadTime / 3)
				particles.emission_shape = 1
				particles.emission_sphere_radius = 30
				particles.local_coords = true
				particles.one_shot = true
				particles.amount = 1
				particles.lifetime = 0.5 * reloadTime
				BarrelPivot.add_child(particles)
		if(reloadTimer >= 60 * reloadTime):
			reloadTimer = 0
			bulletsLoaded = bulletAmount
			
			if(weaponReloadType != "Charge"):
				var particles = Particles.instantiate()
				particles.position = BarrelPivot.position
				particles.emitting = true
				particles.radial_accel_min = -100 / (reloadTime / 3)
				particles.radial_accel_max = -100 / (reloadTime / 3)
				particles.emission_shape = 1
				particles.emission_sphere_radius = 30
				particles.local_coords = true
				particles.one_shot = true
				particles.amount = 30
				particles.lifetime = 0.5 * reloadTime
				BarrelPivot.add_child(particles)
	
func activate_right_click():
	pass
	
func release_left_click():
	rotationSpeed = baseRotationSpeed
	if(weaponReloadType == "Charge"):
		reloadTimer = 0
	
func release_right_click():
	pass
	
func useLeft():
	if(bulletType != null):
		var bullet = bulletType.instantiate()
		bullet.dir = WeaponPivot.rotation + deg_to_rad(randf_range(-spread, spread))
		bullet.speed = bulletSpeed
		bullet.pos = Barrel.global_position
		bullet.rot = BarrelPivot.global_rotation - rotation
		bullet.scale.x = 2
		bullet.damage = bulletDamage
		if(get_parent().get_parent().is_in_group("Player") == true):
			bullet.add_to_group("PlayerBullets")
		else:
			bullet.add_to_group("EnemyBullets")
		
		get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(bullet)
	
	rotationSpeed = baseRotationSpeed / 2
	
	UseAnimationPlayer.stop()
	UseAnimationPlayer.play("use")
	
	var particles = Particles.instantiate()
	particles.global_position = Barrel.global_position
	particles.global_rotation = WeaponPivot.global_rotation
	particles.emitting = true
	particles.lifetime = 1
	particles.direction = Vector2(1, 0)
	particles.initial_velocity_min = 100
	particles.initial_velocity_max = 200
	particles.spread = 5 + spread
	particles.explosiveness = 1
	particles.one_shot = true
	particles.amount = 20
	particles.local_coords = true
	particles.lifetime = 0.8
	get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(particles)
	
func rotating(targetPosition):
	if(flip == true):
		targetPosition *= -1
		
	WeaponPivot.rotation = lerp_angle(WeaponPivot.rotation, (targetPosition - WeaponPivot.position).normalized().angle(), rotationSpeed)
		
