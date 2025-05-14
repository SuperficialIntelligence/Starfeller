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
			
		if(Global.score >= 10):
			if(Input.is_action_just_pressed("ui_1") == true):
				Global.score -= 10
				maxHp += 20
				hp = maxHp
				healthbarUpdate()
				
				playUpgradeSound()
			
			if(Input.is_action_just_pressed("ui_2") == true):
				Global.score -= 10
				maxSpeed += 20
				accelleration += 20
				
				playUpgradeSound()
			
			if(Input.is_action_just_pressed("ui_3") == true):
				Global.score -= 10
				equipsList[0].bulletDamage += 5
				
				playUpgradeSound()
				
			if(Input.is_action_just_pressed("ui_4") == true):
				Global.score -= 10
				equipsList[0].reloadTime /= 1.75
				
				playUpgradeSound()
				
			
func _on_hurt_box_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("EnemyBullets")):
		damageTaken = body.damage
		hitFrom = body.global_rotation
		hurt()

func playUpgradeSound():
	var sound = Sound.instantiate()
	sound.position = position
	sound.pitch_scale = randf_range(0.8, 1.2)
	sound.audio = preload("res://Assets/Sounds/SFX/power_up/powerUp(3).wav")
	get_parent().add_child(sound)
	sound.play()
	
