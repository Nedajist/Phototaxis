extends Camera3D

signal spotted_moth

func _process(delta):
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

	for object in object_list:
		if object.name=="MothEnemy":
			emit_signal("spotted_moth")
