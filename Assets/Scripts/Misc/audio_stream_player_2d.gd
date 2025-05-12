extends AudioStreamPlayer2D
var audio = null
var looping = false

func _ready() -> void:
	stream = audio

func _process(delta: float) -> void:
	if(playing == false and looping == false):
		queue_free()
