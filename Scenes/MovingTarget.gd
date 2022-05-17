extends "res://Scenes/Target.gd"


var dt = 0

func _process(delta):
	dt += delta
	self.global_transform.origin += Vector3(sin(dt+PI/2.0), 0, 0)*0.2
