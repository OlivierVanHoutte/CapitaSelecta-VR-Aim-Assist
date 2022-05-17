extends Spatial

var c_group = -1
var total_shots = 0
var testing = false

func _ready():
	Global.targetGroups = self


func start():	
	for child in get_children():
		child.deactivate()

	c_group = -1
	testing = true
	next_group()
	
func count_shot():
	if testing:
		total_shots += 1

func next_group():
	c_group += 1
	if c_group >= self.get_child_count():
		print("ended")
		print("shots ", total_shots)
		print("total_targets ", 24)
		self.get_parent().show_results()
	else:
		get_child(c_group).activate()
