extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

signal Transitioned

func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
	

func _physics_process(delta):
	look_at(transform.origin + velocity, Vector3.UP)
	
func _on_vision_area_body_entered(body):
	print(body.name)
	if body.name == "PlayerCharacter":
		print("player_seen")
		$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")
