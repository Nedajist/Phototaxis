extends State
class_name MothChase

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var player =   $"../../../PlayerCharacter"
@export var LightSensitive: Area3D
@export var PlayerSensitive: Area3D

var SPEED = randi_range(4,7)

func Enter():
	print("Chase Entered")
	LightSensitive.visible=false
	PlayerSensitive.visible=false	
	
func Exit():
	LightSensitive.visible=true
	PlayerSensitive.visible=true

func Physics_Update(_delta: float):
	if moth_enemy and player:
		moth_enemy.update_target_location(player.global_transform.origin)
		
		var current_location = moth_enemy.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		moth_enemy.velocity = new_velocity
		moth_enemy.move_and_slide()
		
		var distance = player.global_position - moth_enemy.global_position

		if distance.length() > 10:
			Transitioned.emit(self, "MothIdle")
