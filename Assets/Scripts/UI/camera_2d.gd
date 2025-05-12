extends Camera2D

@onready var player = $"../Player"
@onready var speed = 5

var maxZoom = Vector2(2, 2)
var zoomTarget = zoom

func _physics_process(delta: float) -> void:
	
	if(is_instance_valid(player)):
		position = lerp(position, player.position + (get_viewport().get_mouse_position() - get_viewport_rect().size/2)/2, speed*delta)
	
	if(Input.is_action_just_pressed("ui_scroll_up") == true):
		zoomTarget += Vector2(0.1, 0.1)
	if(Input.is_action_just_pressed("ui_scroll_down") == true):
		zoomTarget -= Vector2(0.1, 0.1)
	
	zoomTarget = clamp(zoomTarget, Vector2(0.5, 0.5), maxZoom)
	
	zoom = lerp(zoom, zoomTarget, speed*delta)
