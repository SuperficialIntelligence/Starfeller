extends CharacterEntity

func _physics_process(delta: float) -> void:
	XDirection = Input.get_axis("ui_left", "ui_right")
	YDirection = Input.get_axis("ui_up", "ui_down")
	
	targetPosition = get_local_mouse_position()
	eyeMovements()
	movement()
	moveEquip()
	moveRings()
	idleMoveEquip()
	
	if(equipsList != null):
		for item in activeEquips:
			recoil = item.recoil
		if(Input.is_action_pressed("ui_left_click") == true):
			useEquipLeft()
		if(Input.is_action_just_pressed("ui_shift") == true):
			for item in activeEquips:
				if(item.flip == false):
					flipEquip()
				else:
					unFlipEquip()
			
		if(Input.is_action_just_released("ui_left_click") == true):
			releaseEquipLeft()
			
		if(Input.is_action_just_pressed("ui_right_click") == true):
			swapEquip()
			
func _on_hurt_box_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("EnemyBullets")):
		damageTaken = body.damage
		hitFrom = body.global_rotation
		hurt()
