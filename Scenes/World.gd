extends Spatial


onready var ovr_FirstPerson:ARVROrigin = $OVRFirstPerson
var dragging = false
var offset:Transform
var dist:float = 2

export (NodePath) var lh_path 
onready var lh = get_node(lh_path)
export (NodePath) var rh_path 
export (NodePath) var rh_path2 
onready var rh = get_node(rh_path)




func set_mode(m):
	if m > 13:
		m = 0
	Global.mode = m
	if Global.mode <= 6:
		$OVRFirstPerson/ARVRControllerL/LeftHandObj/scene.visible = true
		$OVRFirstPerson/ARVRControllerR/RightHandObj/scene.visible = true
		$OVRFirstPerson/ARVRControllerR/RightHand2/scene.visible = false
		rh = get_node(rh_path)
		rh.active = true
		lh.active = true
		get_node(rh_path2).active = false
	else:
		$OVRFirstPerson/ARVRControllerL/LeftHandObj/scene.visible = false
		$OVRFirstPerson/ARVRControllerR/RightHandObj/scene.visible = false
		$OVRFirstPerson/ARVRControllerR/RightHand2/scene.visible = true
		rh = get_node(rh_path2)
		rh.active = true
		lh.active = false
		get_node(rh_path).active = false
		
	if Global.mode == 0 || Global.mode == 7:
		rh.move_self = false
		rh.is_snapping = false
		rh.is_stabilized = false
		lh.move_self = false
		lh.is_snapping = false
		lh.is_stabilized = false
	
	if Global.mode == 1 || Global.mode == 8:
		rh.move_self = false
		rh.is_snapping = false
		rh.is_stabilized = true
		lh.move_self = false
		lh.is_snapping = false
		lh.is_stabilized = true
	
	if Global.mode == 2 || Global.mode == 9:
		rh.move_self = false
		rh.is_snapping = true
		rh.is_stabilized = false
		lh.move_self = false
		lh.is_snapping = true
		lh.is_stabilized = false
	
	if Global.mode == 3 || Global.mode == 10:
		rh.move_self = false
		rh.is_snapping = true
		rh.is_stabilized = true
		lh.move_self = false
		lh.is_snapping = true
		lh.is_stabilized = true
	
	if Global.mode == 4 || Global.mode == 11:
		rh.move_self = true
		rh.is_snapping = false
		rh.is_stabilized = true
		lh.move_self = true
		lh.is_snapping = false
		lh.is_stabilized = true
		
	if Global.mode == 5 || Global.mode == 12:
		rh.move_self = true
		rh.is_snapping = true
		rh.is_stabilized = false
		lh.move_self = true
		lh.is_snapping = true
		lh.is_stabilized = false
	
	if Global.mode == 6 || Global.mode == 13:
		rh.move_self = true
		rh.is_snapping = true
		rh.is_stabilized = true
		lh.move_self = true
		lh.is_snapping = true
		lh.is_stabilized = true
	
	show_mode()
		
var targets = []

func _ready():
	set_mode(1)
#	$ovr_right_hand.connect("pressed", self, "button_pressed")
	$OVRFirstPerson/ARVRControllerL.connect("button_pressed", self, "button_pressed_L")
	$OVRFirstPerson/ARVRControllerR.connect("button_pressed", self, "button_pressed_R")
	$OVRFirstPerson/ARVRControllerL.connect("button_release", self, "button_released_L")
	$OVRFirstPerson/ARVRControllerR.connect("button_release", self, "button_released_R")
#	$TargetGroups.start()
	pass # Replace with function body.


func button_released_L(button):
	pass
	
func button_released_R(button):
	pass
		
func button_pressed_L(button):
	if button == 1:
		lh.is_stabilized = !lh.is_stabilized
	if button == 15:
		$TargetGroups.count_shot()
		lh.shoot()
			

func button_pressed_R(button):
	if button == 1:
		set_mode(Global.mode + 1)
	if button == 15:
		$TargetGroups.count_shot()
		rh.shoot()

func _process(delta):
	if dragging:
		$MeshInstance.global_transform.origin = $OVRFirstPerson/ARVRControllerR.global_transform.origin - $OVRFirstPerson/ARVRControllerR.global_transform.basis.z*dist

func show_mode():
	var s = "mode: " + str(Global.mode)
	print(s)
	$Sprite3D/Viewport.set_text(s)

func show_results():
	var s = ""
	s+= "total shots = " + str($TargetGroups.total_shots)
	s += "/nacc = " + str(24.0/float($TargetGroups.total_shots))
	print()
	print(s)
	$Sprite3D/Viewport.set_text(s)
	$Start.activate()
	pass
