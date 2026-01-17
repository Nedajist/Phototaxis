extends CharacterBody3D

@export var nav_agent: NavigationAgent3D

signal Transitioned


func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
	

func _physics_process(delta):
	if velocity!=Vector3(0,0,0):
		look_at(transform.origin + velocity, Vector3.UP)
	
func _on_vision_area_body_entered(body): #small sphere and cone detector check for physical objects 
	print("moth has spotted: " + body.name)
	if body.name == "PlayerCharacter":
		print("player_seen")
		if randi_range(1,4)==1:
			$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")
		else:
			$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothStalk")


func _on_light_sensitive_area_entered(area: Area3D) -> void: #large sphere collector checks for Area3Ds named MothLight
	if area.name=="MothLight":
		print("moth has felt the light shining")
		$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothFollow")
		$"State Machine/MothFollow".light=area


func _on_moth_stalk_switch_to_chase() -> void:
	$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")
