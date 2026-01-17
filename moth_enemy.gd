extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
	
