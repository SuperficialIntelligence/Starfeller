class_name Trail
extends Line2D

var maxPoints = 20
var timer = 0
@onready var curve := Curve2D.new()

func _physics_process(delta: float) -> void:
	curve.add_point(get_parent().global_position)
	if(curve.get_baked_points().size() > maxPoints):
		curve.remove_point(0)
	
	points = curve.get_baked_points()

func stop():
	set_process(false)
	var tw := get_tree().create_tween()
	tw.tween_property(self, "modulate: a", 0.0, 3.0)
	await tw.finished
	queue_free()

static func create() -> Trail:
	var scn = preload("res://Assets/Scenes/Effects/trail.tscn")
	return scn.instantiate()
