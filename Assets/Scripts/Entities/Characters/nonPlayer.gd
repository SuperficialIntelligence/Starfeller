extends CharacterEntity

var detectedEntities = []
var target
var bulletSpeed = 0

var shootingTimer = 0
var weaponPivot

#AI
@onready var enemyInitialAggro = randf_range(0, 600)
@onready var enemyAggro = enemyInitialAggro 

func _physics_process(delta: float) -> void:
	if(detectedEntities.size() != 0):
		target = detectedEntities[0]
		targetPosition = target.position - position
		enemyInitialAggro = randf_range(global_position.distance_to(targetPosition + global_position), (global_position.distance_to(targetPosition + global_position) <= bulletSpeed))
		enemyAggro = enemyInitialAggro

	if(target != null):
		if((targetPosition.x) <= 0):
			XDirection = -1
		if((targetPosition.x) >= 0):
			XDirection = 1
		if((targetPosition.y) <= 0):
			YDirection = -1
		if((targetPosition.y) >= 0):
			YDirection = 1
		if(global_position.distance_to(targetPosition + global_position) < enemyAggro):
			XDirection *= -1
			YDirection *= -1
	
	moveRings()
	idleMoveEquip()
	moveEquip()
	movement()
	eyeMovements()

	if(equipsList != null):
		for item in activeEquips:
			recoil = item.recoil
			weaponPivot = item.WeaponPivot
			bulletSpeed = item.bulletSpeed
			if(item.bulletsLoaded >= 0):
				enemyAggro = 0
			else:
				enemyAggro = enemyInitialAggro
			
		if(slot == 1 and not (global_position.distance_to(targetPosition + global_position) < enemyAggro or global_position.distance_to(targetPosition + global_position) > 1000)):
			slot = 0
			if(equipsList.size() <= slot):
				slot = 0
			activeEquips.append(equipsList[slot])
			activeEquips.pop_front()
		else:
			slot = 1
			if(equipsList.size() < slot):
				slot = 0
			activeEquips.append(equipsList[slot])
			activeEquips.pop_front()
			
		if((global_position.distance_to(targetPosition + global_position) > enemyAggro) and slot == 1):
			flipEquip()
		else:
			unFlipEquip()
			
		if(weaponPivot.rotation < weaponPivot.rotation + abs((targetPosition - weaponPivot.position).normalized().angle() * 1.1)):
			for item in activeEquips:
				if((global_position.distance_to(targetPosition + global_position) <= bulletSpeed) or item.weaponType == "StellarEngine"):
					useEquipLeft()
		else:
			releaseEquipLeft()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") == true):
		if(!detectedEntities.has(body)):
			detectedEntities.append(body)
			

func _on_detection_area_body_exited(body: Node2D) -> void:
	if(detectedEntities.has(body)):
		detectedEntities.erase(body)
	
	if(detectedEntities.size() != 0):
		target = detectedEntities[0]
	else:
		target = null

func _on_hurt_box_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("PlayerBullets")):
		damageTaken = body.damage
		hitFrom = body.global_rotation
		hurt()
