extends Spatial


func shot():
	Global.targetGroups.start()
	self.deactivate()
#	queue_free()
	pass

func deactivate():
	self.visible = false
	$Area.monitorable = false
	$Area/CollisionShape.disabled = true
	pass
	
func activate():
	self.visible = true
	$Area.monitorable = true
	$Area/CollisionShape.disabled = false
	pass
