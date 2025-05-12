extends Camera2D

@onready var player = $"../Player"
@onready var speed = 5
@onready var Sound = preload("res://Assets/Scenes/Misc/audio_stream_player_2d.tscn")

var maxZoom = Vector2(2, 2)
var zoomTarget = zoom

var MusicAll = []
var MusicOn = []

var musicTime = 24.02
var musicTimer = 0

var musicVolume = -5


func _ready() -> void:
	var startSound = Sound.instantiate()
	startSound.position = position
	startSound.pitch_scale = 2
	startSound.audio = preload("res://Assets/Sounds/SFX/synth/synth(1).wav")
	add_child(startSound)
	startSound.play()
	
	var Music1 = Sound.instantiate()
	Music1.position = position
	Music1.looping = true
	Music1.volume_db = musicVolume
	MusicAll.append(Music1)
	Music1.audio = preload("res://Assets/Sounds/Music/MainTheme/Track1_Instrument.wav")
	
	var Music2 = Sound.instantiate()
	Music2.position = position
	Music2.looping = true
	Music2.volume_db = musicVolume
	MusicAll.append(Music2)
	Music2.audio = preload("res://Assets/Sounds/Music/MainTheme/Track2_Instrument.wav")
	
	var Music3 = Sound.instantiate()
	Music3.position = position
	Music3.looping = true
	Music3.volume_db = musicVolume
	MusicAll.append(Music3)
	Music3 .audio = preload("res://Assets/Sounds/Music/MainTheme/Track3_Instrument.wav")
	
	var Music4 = Sound.instantiate()
	Music4.position = position
	Music4.looping = true
	Music4.volume_db = musicVolume
	MusicAll.append(Music4)
	Music4.audio = preload("res://Assets/Sounds/Music/MainTheme/Track4_Instrument.wav")
	
	var Music5 = Sound.instantiate()
	Music5.position = position
	Music5.looping = true
	Music5.volume_db = musicVolume
	MusicAll.append(Music5)
	Music5.audio = preload("res://Assets/Sounds/Music/MainTheme/Track5_Instrument.wav")
	
	var Music6 = Sound.instantiate()
	Music6.position = position
	Music6.looping = true
	Music6.volume_db = musicVolume
	MusicAll.append(Music6)
	Music6.audio = preload("res://Assets/Sounds/Music/MainTheme/Track6_Instrument.wav")
	
	var Music7 = Sound.instantiate()
	Music7.position = position
	Music7.looping = true
	Music7.volume_db = musicVolume
	MusicAll.append(Music7)
	Music7.audio = preload("res://Assets/Sounds/Music/MainTheme/Track7_Instrument.wav")
	
	for music in MusicAll:
		music.playing = false
		add_child(music)
		
	musicTimer = musicTime * 60 - 1

func _physics_process(delta: float) -> void:
	
	if(is_instance_valid(player)):
		position = lerp(position, player.position + (get_viewport().get_mouse_position() - get_viewport_rect().size/2)/2, speed*delta)
	
	if(Input.is_action_just_pressed("ui_scroll_up") == true):
		zoomTarget += Vector2(0.1, 0.1)
	if(Input.is_action_just_pressed("ui_scroll_down") == true):
		zoomTarget -= Vector2(0.1, 0.1)
	
	zoomTarget = clamp(zoomTarget, Vector2(0.5, 0.5), maxZoom)
	
	zoom = lerp(zoom, zoomTarget, speed*delta)
	
	songCheck()
	
func songCheck():
	musicTimer += 1
	if(musicTimer > 60 * musicTime):
		var chaos = Global.chaos
	
		if(chaos > MusicOn.size()):
			for music in MusicAll:
				if(chaos > MusicOn.size()):
					music = MusicAll.pick_random()
					if(MusicOn.has(music) == false):
						MusicOn.append(music)
					
		elif(chaos < MusicOn.size()):
			for music in MusicAll:
				if(chaos < MusicOn.size()):
					music = MusicOn.pick_random()
					if(MusicOn.has(music) == true):
							MusicOn.erase(music)
							
		if(MusicOn.size() > 0):
			for music in MusicOn:
				music.play()
		musicTimer = 0
