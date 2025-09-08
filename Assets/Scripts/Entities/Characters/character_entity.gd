class_name CharacterEntity
extends CharacterBody2D

@onready var Outline = $BodyCenter/Outline
@onready var Body = $BodyCenter/Body
@onready var EyesPivot = $BodyCenter/EyesPivot
@onready var Eyes = $BodyCenter/EyesPivot/Eyes
@onready var Equips = $Equips
@onready var Rings = $Rings
@onready var HurtBoxArea = $HurtBoxArea
@onready var HealthBar = $HealthBar
@onready var Sound = preload("res://Assets/Scenes/Misc/audio_stream_player_2d.tscn")
@onready var Particles = preload("res://Assets/Scenes/Particles/particles.tscn")
@onready var UREB = preload("res://Assets/Scenes/Entities/Weapons/ureb.tscn")
@onready var StellarEngine = preload("res://Assets/Scenes/Entities/Weapons/stellar_engine.tscn")
@onready var Electroshotgun = preload("res://Assets/Scenes/Entities/Weapons/electroshotgun.tscn")
@onready var GameOverScreen = preload("res://Assets/Scenes/UI/game_over.tscn")

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
var damage = 10

#misc
var damageTaken = 0
var hitFrom
var weapon
var weaponRandomizer
var isDead = false

func _ready() -> void:
	HealthBar.self_modulate = Body.self_modulate * 2
		
	initialize_stats()
	healthbarUpdate()
	createTrail()
	
	weaponRandomizer = randi_range(0,1)
	if(weaponRandomizer == 0):
		weapon = Electroshotgun.instantiate()
	else:
		weapon = UREB.instantiate()
	Equips.add_child(weapon)
	equipsList.append(weapon)
	
	weapon = StellarEngine.instantiate()
	Equips.add_child(weapon)
	equipsList.append(weapon)
	
	activeEquips.append(equipsList[slot])
	
	if(is_in_group("Enemy")):
		Global.chaos += 1
		
	for item in equipsList:
		item.WeaponSprite.self_modulate = Body.self_modulate
		item.BarrelSprite.self_modulate = Body.self_modulate
	
func initialize_stats():
	maxEyeDistance = charactersDictionary[type]["maxEyeDistance"]
	eyeSpeed = charactersDictionary[type]["eyeSpeed"]

	maxSpeed = charactersDictionary[type]["maxSpeed"]
	accelleration = charactersDictionary[type]["accelleration"]
	friction = charactersDictionary[type]["friction"]

	rotationSpeed = charactersDictionary[type]["rotationSpeed"]
	damage = charactersDictionary[type]["damage"]
	
	maxHp = charactersDictionary[type]["maxHp"]
	hp = maxHp
	
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
		recoilDirection = -recoilDirection
	
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
	particles.amount = 10
	particles.local_coords = true
	particles.color = Body.self_modulate * 2
	particles.lifetime = 0.8
	get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(particles)
	
	var sound = Sound.instantiate()
	sound.position = position
	sound.pitch_scale = randf_range(0.8, 1.2)
	
	var random = randi_range(0, 1)
	if(random == 0):
		sound.audio = preload("res://Assets/Sounds/SFX/hit_hurt/hitHurt(2).wav")
	else:
		sound.audio = preload("res://Assets/Sounds/SFX/hit_hurt/hitHurt(5).wav")
	get_parent().add_child(sound)
	sound.play()
	
	
	if(hp <= 0 and isDead == false):
		particles = Particles.instantiate()
		particles.global_position = global_position
		particles.emitting = true
		particles.direction = Vector2(1, 0)
		particles.initial_velocity_min = 0
		particles.initial_velocity_max = 50
		particles.spread = 180
		particles.explosiveness = 1
		particles.one_shot = true
		particles.amount = 20
		particles.color = Body.self_modulate * 2
		particles.local_coords = true
		particles.lifetime = 6
		particles.scale = Vector2(2, 2)
		get_tree().root.get_child(3).get_node("CanvasMainLayer").add_child(particles)
		
		if(is_in_group("Player") == false):
			Global.score += 10
			Global.chaos -= 1
		else:
			var endScreen = GameOverScreen.instantiate()
			get_parent().add_child(endScreen)
		
		sound = Sound.instantiate()
		sound.position = position
		sound.pitch_scale = randf_range(0.8, 1.2)
		sound.audio = preload("res://Assets/Sounds/SFX/explosion/explosion(2).wav")
		get_parent().add_child(sound)
		sound.play()


		isDead = true
		queue_free()
		
	
func healthbarUpdate():
	HealthBar.value = hp
	HealthBar.max_value = maxHp
