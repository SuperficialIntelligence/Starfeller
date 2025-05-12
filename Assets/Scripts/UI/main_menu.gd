extends Control

@onready var AnimationPlay = $AnimationPlayer

func _ready() -> void:
	AnimationPlay.play("fade_in")
	Global.chaos = 2

func _on_start_button_pressed() -> void:
	Global.chaos = 1
	Global.score = 0
	get_tree().change_scene_to_file("res://Assets/Scenes/Levels/test_level.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
