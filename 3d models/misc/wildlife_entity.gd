extends CharacterBody3D
@export var move_timer=10
@export var move_speed=3.0
@export var nav_agent: NavigationAgent3D

var current_time=1
var target_point
var movement_started=false
func _physics_process(delta: float) -> void:
	current_time-=delta
	if (current_time)<=0:
		current_time=move_timer
		var random_point=NavigationServer3D.map_get_random_point(NavigationServer3D.get_maps()[0], 1, false)
		target_point=random_point
		movement_started=true
		
	if movement_started:
		nav_agent.target_position=target_point
		var current_location = self.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * move_speed


		self.velocity = new_velocity
		if velocity!=Vector3(0,0,0):
			look_at(transform.origin + velocity, Vector3.UP)
	
	move_and_slide()
