class_name CharacterEntity
extends CharacterBody2D

@onready var Outline = $Outline
@onready var Body = $Body
@onready var EyesPivot = $BodyCenter/EyesPivot
@onready var Eyes = $BodyCenter/EyesPivot/Eyes
@onready var Equips = $Equips
@onready var Rings = $Rings
@onready var HurtBoxArea = $HurtBoxArea
@onready var HealthBar = $HealthBar
@onready var Particles = preload("res://Assets/Scenes/Particles/particles.tscn")
@onready var UREB = preload("res://Assets/Scenes/Entities/Weapons/ureb.tscn")
@onready var StellarEngine = preload("res://Assets/Scenes/Entities/Weapons/stellar_engine.tscn")

@onready var charactersDictionary = CharactersDictionary.CharactersDictionary

@export var type = "GStar"

#Targeting
var maxEyeDistance = 5
var targetPosition: Vector2
var targetDistance = 0
var eyeSpeed = 0.1

#Physics
var maxSpeed = 200
var accelleration = 20
var friction = 1

var xSpeed = 0
var ySpeed = 0

var recoil = 0
var recoilDirection: Vector2

var XDirection = 0
var YDirection = 0
#Equips
var equipsList = []
var activeEquips = []
var slot = 0

#Equip Rotation
var rotationSpeed = 0.1

#Trail
var currentTrail

#Stats
var maxHp = 100
var hp = maxHp

#misc
var damageTaken = 0
var hitFrom

func _ready() -> void:
	healthbarUpdate()
	createTrail()
	
	var weapon = UREB.instantiate()
	Equips.add_child(weapon)
	equipsList.append(weapon)
	
	weapon = StellarEngine.instantiate()
	Equips.add_child(weapon)
	equipsList.append(weapon)
	
	activeEquips.append(equipsList[slot])
	
func initialize_stats():
	maxEyeDistance = charactersDictionary[type]["maxEyeDistance"]
	eyeSpeed = charactersDictionary[type]["eyeSpeed"]

	maxSpeed = charactersDictionary[type]["maxSpeed"]
	accelleration = charactersDictionary[type]["accelleration"]
	friction = charactersDictionary[type]["friction"]

	var rotationSpeed = charactersDictionary[type]["rotationSpeed"]
	
func eyeMovements():
	var lookDirection = Vector2.ZERO.direction_to(targetPosition)
	targetDistance = targetPosition.length()
	Eyes.position = lerp(Eyes.position, lookDirection * min(targetDistance, maxEyeDistance), eyeSpeed)

func movement():
	xSpeed += XDirection * accelleration
	ySpeed += YDirection * accelleration
	
	if(xSpeed > 0):
		xSpeed -= friction
	if(xSpeed < 0):
		xSpeed += friction
	
	if(ySpeed > 0):
		ySpeed -= friction
	if(ySpeed < 0):
		ySpeed += friction
		
	if(xSpeed > maxSpeed):
		xSpeed -= (friction + accelleration)
	if(xSpeed < -maxSpeed):
		xSpeed += (friction + accelleration)
	
	if(ySpeed > maxSpeed):
		ySpeed -= (friction + accelleration)
	if(ySpeed < -maxSpeed):
		ySpeed += (friction + accelleration)
	
	velocity.x = xSpeed
	velocity.y = ySpeed
	
	velocity.normalized()
	
	move_and_slide()

func useEquipLeft():
	for item in activeEquips:
		item.activate_left_click()
	
		recoilDirection = Vector2(cos(item.WeaponPivot.global_rotation), sin(item.WeaponPivot.global_rotation))
		recoilDirection = -recoilDirection.normalized()
	
	xSpeed += recoil * recoilDirection.x
	ySpeed += recoil * recoilDirection.y

func useEquipRight():
	for item in activeEquips:
		item.activate_right_click()
		
func flipEquip():
	for item in activeEquips:
		item.flip = true
		
func releaseEquipLeft():
	for item in activeEquips:
		item.release_left_click()

func releaseEquipRight():
	for item in activeEquips:
		item.release_right_click()
		
func unFlipEquip():
	for item in activeEquips:
		item.flip = false

func moveEquip():
	for item in activeEquips:
		item.rotating(targetPosition)
		
func idleMoveEquip():
	for item in equipsList:
		if(item != equipsList[slot]):
			item.global_rotation += 0.01
	
	for item in activeEquips:
		item.global_rotation = lerp(item.global_rotation, 0.0, 0.2)
		
func swapEquip():
	slot += 1
	if(equipsList.size() <= slot):
		slot = 0
	activeEquips.append(equipsList[slot])
	activeEquips.pop_front()
	
func moveRings():
	Rings.rotation += 0.02

func createTrail():
	if(currentTrail):
		currentTrail.stop
	currentTrail = Trail.create()
	add_child(currentTrail)

func hurt():
	hp -= damageTaken
	HealthBar.visible = true
	healthbarUpdate()
	
	var particles = Particles.instantiate()
	particles.global_position = global_position
	particles.global_rotation = hitFrom
	particles.emitting = true
	particles.direction = Vector2(1, 0)
	particles.initial_velocity_min = 100
	particles.initial_velocity_max = 600
	particles.spread = 10
	particles.explosiveness = 1
	particles.one_shot = true
	particles.amount = 50
	particles.local_coords = true
	particles.lifetime = 0.8
	get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(particles)
	
	
	if(hp <= 0):
		particles = Particles.instantiate()
		particles.global_position = global_position
		particles.emitting = true
		particles.direction = Vector2(1, 0)
		particles.initial_velocity_min = 0
		particles.initial_velocity_max = 50
		particles.spread = 180
		particles.explosiveness = 1
		particles.one_shot = true
		particles.amount = 100
		particles.local_coords = true
		particles.lifetime = 6
		particles.scale = Vector2(2, 2)
		get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(particles)
		
		if(is_in_group("Player") == false):
			Global.score += 10
		
		queue_free()
		
	
func healthbarUpdate():
	HealthBar.value = hp
	HealthBar.max_value = maxHp
