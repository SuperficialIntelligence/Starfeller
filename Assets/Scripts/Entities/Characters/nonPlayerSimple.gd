extends CharacterEntity

var detectedEntities = []
var target

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
	
	moveRings()
	idleMoveEquip()
	moveEquip()
	movement()
	eyeMovements()

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
