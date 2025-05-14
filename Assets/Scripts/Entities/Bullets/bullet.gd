extends CharacterBody2D

@onready var BulletDetail = $BulletSprite/BulletDetail
@onready var BulletOutline = $BulletSprite/BulletOutline
@onready var Center = $Center
@onready var CollisionBox = $CollisionBox
@onready var FadeAnimation = $FadeAnimation
var col = Color(255, 255, 255)
var pos: Vector2
var rot: float
var dir: float
var speed = 1000
var damage = 10

func _ready() -> void:
	global_position = pos
	global_rotation = rot
	Center.rotation = rot
	FadeAnimation.play("fadeOut")

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()
