extends CharacterEntity

var detectedEntities = []
var detectedBullets = []
var target
var targetBullet

var shootingTimer = 0
var weaponPivot

func _physics_process(delta: float) -> void:
	if(detectedEntities.size() != 0):
		target = detectedEntities[0]
		targetPosition = target.position - position
			
	if(detectedBullets.size() != 0):
		targetBullet = detectedBullets[0]
		if(global_position.distance_to(targetBullet.position + position) < 500):
			targetPosition = -(targetBullet.position - position)
			
	if(targetBullet != null or target != null):
		if((targetPosition.x - position.x) < 0):
			XDirection = -1
		if((targetPosition.x - position.x) > 0):
			XDirection = 1
		if((targetPosition.y - position.y) < 0):
			YDirection = -1
		if((targetPosition.y - position.y) > 0):
			YDirection = 1
		if(global_position.distance_to(targetPosition + position) < 750):
			XDirection *= -1
			YDirection *= -1
			
	
	moveRings()
	idleMoveEquip()
	moveEquip()
	movement()
	eyeMovements()

	if(equipsList != null):
		shootingTimer += 1 
		for item in activeEquips:
			recoil = item.recoil
			weaponPivot = item.WeaponPivot
			
			if(weaponPivot.rotation < weaponPivot.rotation + abs((targetPosition - weaponPivot.position).normalized().angle() * 1.1)):
				useEquipLeft()
			else:
				releaseEquipLeft()
			
		if(((global_position.distance_to(targetPosition + position) < 750 or global_position.distance_to(targetPosition + position) > 2000) and slot != 1)):
			slot = 1
			if(equipsList.size() <= slot):
				slot = 0
			activeEquips.append(equipsList[slot])
			activeEquips.pop_front()
			if((global_position.distance_to(targetPosition + position) > 2000) and slot == 1):
				for item in activeEquips:
					if(item.flip == false):
						flipEquip()
			else:
				for item in activeEquips:
					if(item.flip == true):
						unFlipEquip()
		elif(slot == 1):
			slot = 0
			if(equipsList.size() <= slot):
				slot = 0
			activeEquips.append(equipsList[slot])
			activeEquips.pop_front()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") == true):
		if(!detectedEntities.has(body)):
			detectedEntities.append(body)
	
	if(body.is_in_group("PlayerBullets") == true):
		if(!detectedBullets.has(body)):
			detectedBullets.append(body)
			

func _on_detection_area_body_exited(body: Node2D) -> void:
	if(detectedEntities.has(body)):
		detectedEntities.erase(body)
	
	if(detectedBullets.has(body)):
		detectedBullets.erase(body)
	
	if(detectedEntities.size() != 0):
		target = detectedEntities[0]
	else:
		target = null
		
	if(detectedBullets.size() != 0):
		targetBullet = detectedBullets[0]
	else:
		targetBullet = null

func _on_hurt_box_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("PlayerBullets")):
		damageTaken = body.damage
		hitFrom = body.global_rotation
		hurt()
