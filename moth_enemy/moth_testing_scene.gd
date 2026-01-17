extends Node

@onready var player = $PlayerCharacter

func _physics_process(delta):
	pass#get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
