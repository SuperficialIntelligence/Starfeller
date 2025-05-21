extends CharacterEntity

var detectedEntities = []
var detectedBullets = []
var target
var targetBullet

var shootingTimer = 0
var weaponPivot

#AI
@onready var enemyAggro = randf_range(0, 600)

func _physics_process(delta: float) -> void:	
			
	if(detectedEntities.size() != 0):
		target = detectedEntities[0]
		targetPosition = target.position - position
			
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
			
		if((global_position.distance_to(targetPosition + global_position) > 1000) and slot == 1):
			flipEquip()
		else:
			unFlipEquip()
			
		if(weaponPivot.rotation < weaponPivot.rotation + abs((targetPosition - weaponPivot.position).normalized().angle() * 1.1)):
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
