extends State
class_name MothIdle

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent: NavigationAgent3D
@onready var player: CharacterBody3D

var move_direction : Vector3
var wander_time : float

func randomize_wander():
	moth_enemy.update_target_location(moth_enemy.global_transform.origin+Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()*randf_range(-10,10))
	wander_time = randf_range(1, 3)
		
func Enter():
	print("moth entered idle state")
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(_delta: float):
	pass
	if moth_enemy:
		var current_location = moth_enemy.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * move_speed
		
		moth_enemy.velocity = new_velocity
		moth_enemy.move_and_slide()
