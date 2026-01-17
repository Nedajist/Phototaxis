extends State
class_name MothStalk

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var player =   $"../../../PlayerCharacter"
@export var LightSensitive: Area3D
@export var PlayerSensitive: Area3D

var SPEED = 2.0
var position_update_time=0
var chase_chance=15
signal switch_to_chase

func Enter():
	print("Stalk Entered")
	LightSensitive.visible=false
	PlayerSensitive.visible=false
	
func Exit():
	LightSensitive.visible=true
	PlayerSensitive.visible=true

func Physics_Update(_delta: float):
	if position_update_time<=0:
		if randi_range(1,100)<=chase_chance:
			emit_signal("switch_to_chase")
		else:
			chase_chance+=5
			position_update_time=randf_range(0.3,2)
			if moth_enemy and player:
				var halfway_point=(player.global_transform.origin + moth_enemy.transform.origin) * 0.5
				moth_enemy.update_target_location(halfway_point)
			

	else:
		position_update_time-=_delta
		
	var current_location = moth_enemy.global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
			
	moth_enemy.velocity = new_velocity
	moth_enemy.move_and_slide()
			
	var distance = player.global_position - moth_enemy.global_position

	if distance.length() > 20:
		Transitioned.emit(self, "MothIdle")
