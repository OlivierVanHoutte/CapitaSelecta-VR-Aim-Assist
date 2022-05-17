extends Spatial

var cleared = 0


func activate():
	cleared = 0 
	self.visible = true
	for child in get_children():
		child.activate()

func deactivate():
	self.visible = false
	for child in get_children():
		child.deactivate()
	pass

func add_cleared():
	cleared += 1
	if cleared >= get_child_count():
		self.deactivate()
		self.get_parent().next_group()
			
	
	
