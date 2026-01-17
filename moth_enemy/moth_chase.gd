extends State
class_name MothChase

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var player =   $"../../../PlayerCharacter"

var SPEED = 3.0

func Enter():
	print("Chase Entered")

func Physics_Update(_delta: float):
	if moth_enemy and player:
		moth_enemy.update_target_location(player.global_transform.origin)
		
		var current_location = moth_enemy.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		moth_enemy.velocity = new_velocity
		moth_enemy.move_and_slide()
		
		var distance = player.global_position - moth_enemy.global_position
		#print("chasing")
		#if distance.length() > 10:
			#Transitioned.emit(self, "MothIdle")
