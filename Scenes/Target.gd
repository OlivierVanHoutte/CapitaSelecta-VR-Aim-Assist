extends MeshInstance

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func shot():
	$AudioStreamPlayer.play()
	self.deactivate()
	self.get_parent().add_cleared()

func activate():
	Global.targets.append(self)
	active = true
	$Area.monitorable = true
	$Area.monitoring = true
	$Area/CollisionShape.disabled = false
	visible = true
	pass
	
func deactivate():
	Global.targets.erase(self)
	active = false
	$Area.monitorable = false
	$Area.monitoring = false
	$Area/CollisionShape.disabled = true
	visible = false
	pass
