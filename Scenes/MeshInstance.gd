extends MeshInstance

var inside = 0

func _ready():
	$Area.connect("body_entered", self, "entered")
	$Area.connect("body_exited", self, "exited")
	
func entered(body):
	inside += 1
	var mat = material_override as SpatialMaterial
	mat.albedo_color = Color(1, 0, 0, 1)
	pass
	
func exited(body):
	inside -= 1
	if inside == 0:
		var mat = material_override as SpatialMaterial
		mat.albedo_color =  Color(1, 1, 1, 1)
	pass
	
