extends State
class_name MothFollow

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var player =  $"../../../PlayerCharacter"
@onready var light = $"../../../MothAnchor"

var SPEED = 3.0

func Enter():
	print("Follow Entered")

func Physics_Update(_delta: float):
	if moth_enemy and player:
		moth_enemy.update_target_location(light.global_transform.origin)
		
		var current_location = moth_enemy.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		moth_enemy.velocity = new_velocity
		moth_enemy.move_and_slide()
		
		#var player_distance = player.global_position - moth_enemy.global_position
		#if player_distance.length() < 5:
		#	print(player_distance.length())
		#	print("Start chase")
		#	Transitioned.emit(self, "MothChase")
