extends Control
@onready var score = $CanvasLayer/Score

func _process(delta: float) -> void:
	score.text = "Score: " + str(Global.score)
