extends Camera3D

signal spotted_moth
signal moth_out_of_view

var looking_at_moth: bool = false

func _process(_delta):
	var object_list=[]
	var exclude_list=[]
	
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = self.project_ray_origin(mouse_pos)
	var to = from + self.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.exclude=exclude_list
	var raycast_result = space.intersect_ray(ray_query)
	
	while not raycast_result.is_empty():
		exclude_list.append(raycast_result.get("rid"))
		ray_query.exclude=exclude_list
		object_list.append(raycast_result.get("collider"))
		raycast_result = space.intersect_ray(ray_query)
	var moth_spotted:bool = false
	#print("__________START__________")
	for object in object_list:
		#print(object)
		if object.is_in_group("Wall"):
			#print("WALL")
			break
		if object.is_in_group("Enemies"):
			moth_spotted = true
			looking_at_moth = true
			emit_signal("spotted_moth", object)
		if object.name == "HoldPlayerCamera":
			moth_spotted = true
	#print(moth_spotted)
	#print("__________END__________")
	if !moth_spotted and looking_at_moth:
		emit_signal("moth_out_of_view")
