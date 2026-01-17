extends CharacterBody3D

@export var nav_agent: NavigationAgent3D

signal Transitioned

func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
	

func _physics_process(delta):
	if velocity!=Vector3(0,0,0):
		look_at(transform.origin + velocity, Vector3.UP)
	
func _on_vision_area_body_entered(body):
	print("moth has spotted: " + body.name)
	if body.name == "PlayerCharacter":
		print("player_seen")
		$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")


func _on_light_sensitive_area_entered(area: Area3D) -> void:
	if area.name=="MothLight":
		print("moth has felt the light shining")
		$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothFollow")
		$"State Machine/MothFollow".light=area
