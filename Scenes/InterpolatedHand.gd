extends Spatial
export (NodePath) var target_path

onready var target_dir = get_node(target_path)
onready var target_ray = target_dir.get_node("RayCast")

var base_dir_weight = 1.0
#var base_dist_weight = 1.0

var is_stabilized = false
var is_snapping = true
var move_self = false

var active = true

var stab_result

func _ready():
	self.global_transform = target_dir.global_transform 
	self.set_as_toplevel(true)

func _physics_process(_delta):
	$scene/RayCast.visible = Global.mode < 7
	$Spatial.visible = !move_self
	if active:
		
		if is_stabilized:
			stabilize()
		elif !is_snapping:
			var forward = get_parent().get_node("RayCast").get_global_transform().basis.x
			self.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - forward, get_parent().get_node("RayCast").global_transform.basis.y)
			
		if !move_self || !is_snapping && !is_stabilized:
			self.set_as_toplevel(false)
		else:
			self.set_as_toplevel(true)
			
		if is_snapping:
			snap_to_targets()



func stabilize():
		var forward = get_parent().get_node("RayCast").get_global_transform().basis.x
		var t_dir = self.global_transform.looking_at(self.global_transform.origin - forward, get_parent().get_node("RayCast").global_transform.basis.y).basis
#		var dist_weight:float = sqrt((self.global_transform.origin - target.global_transform.origin).length()/2.0)
		var dir_weight = sqrt(sqrt((1.0 - self.global_transform.basis.z.dot(forward))/2.0))
		
		var e_dir_weight = dir_weight*base_dir_weight
#		var e_dist_weight = dist_weight*base_dist_weight
		e_dir_weight = clamp(e_dir_weight, 0.0, 1.0)
#		if e_dist_weight > 0.001:
#			self.global_transform.origin += (target.global_transform.origin - self.global_transform.origin) * e_dist_weight
		if e_dir_weight > 0.001:
			var norm_basis = self.global_transform.basis.orthonormalized()
			var target_basis = t_dir.orthonormalized()
			stab_result = t_dir.slerp(norm_basis, 1.0 - e_dir_weight)
			if move_self:
				self.global_transform.basis = t_dir.slerp(norm_basis, 1.0 - e_dir_weight)
			else:
				self.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - forward, get_parent().get_node("RayCast").global_transform.basis.y)
				norm_basis = $Spatial.global_transform.basis.orthonormalized()
				$Spatial.global_transform.basis = t_dir.slerp(norm_basis, 0.001 - e_dir_weight)
				$Spatial.global_transform.origin = self.global_transform.origin
#				$Spatial.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - t_dir.slerp(norm_basis, 1.0 - e_dir_weight).z, get_parent().get_node("RayCast").global_transform.basis.y) 
#				$Spatial.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - forward, get_parent().get_node("RayCast").global_transform.basis.y)
			
				
func snap_to_targets():

	var forward = get_parent().get_node("RayCast").get_global_transform().basis.x
	
	if is_stabilized:
		forward = stab_result.z
	
	var base_weight = 1.0
	var tot_dir = forward*base_weight
	
	for target in Global.targets:
		var dir = self.global_transform.origin.direction_to(target.global_transform.origin)
		var dist = self.global_transform.origin.distance_to(target.global_transform.origin)
		dir = dir.normalized()
		var d = forward.dot(dir)
		var weight = clamp(pow(d, 10001), 0, 1)*log(dist)
		tot_dir += dir*weight

	
	var final_dir = tot_dir.normalized()
	if move_self:
		self.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - final_dir, get_parent().get_node("RayCast").global_transform.basis.y)
	else:
		$Spatial.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - final_dir, get_parent().get_node("RayCast").global_transform.basis.y)
		self.global_transform = get_parent().global_transform.looking_at(get_parent().global_transform.origin - forward, get_parent().get_node("RayCast").global_transform.basis.y)

	pass

func shoot():
	$scene/RayCast.force_raycast_update()
	if move_self:
		if $scene/RayCast.is_colliding():
			$scene/RayCast.get_collider().get_parent().shot()
	else:
		if $Spatial/Spatial/RayCast.is_colliding():
			$Spatial/Spatial/RayCast.get_collider().get_parent().shot()
	$scene/AudioStreamPlayer3D.play()
	$scene/AnimationPlayer.play("Shoot")
		
	
	
	
	
