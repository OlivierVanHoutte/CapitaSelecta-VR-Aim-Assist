extends ARVRController

signal controller_activated(controller)

export var show_controller_mesh = true setget set_show_controller_mesh, get_show_controller_mesh

func set_show_controller_mesh(p_show):
	show_controller_mesh = p_show
	if $OVRRenderModel:
		$OVRRenderModel.visible = p_show

func get_show_controller_mesh():
	return show_controller_mesh

func _ready():
	# set our starting vaule
	$OVRRenderModel.visible = show_controller_mesh
	
	# hide to begin with
	visible = false

func _process(delta):
	if !get_is_active():
		visible = false
		return
	
	if visible:
		return
	
	# make it visible
	visible = true
	emit_signal("controller_activated", self)

func _on_ARVRController2_button_pressed(button):
	if button == 1:
		print ("Menu button pressed!")
	elif button == 2:
		print ("Grip button pressed!")
	elif button == 15:
		print("Trigger pressed!")
	else:
		print ("Button with index: " + String(button) + " was pressed!")
