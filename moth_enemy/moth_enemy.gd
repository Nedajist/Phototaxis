extends CharacterBody3D

@export var player_character: CharacterBody3D
@export var nav_agent: NavigationAgent3D
var player_ui:CanvasLayer
var on_screen:bool = false
var stalk_timer_active:bool = false

func _ready() -> void:
	for node in $"State Machine".get_children():
		if "player" in node:
			node.player=player_character
		if "nav_agent" in node:
			node.nav_agent=nav_agent
	print(player_character)
	player_ui = player_character.get_node("HudCanvasLayer")
	player_ui.blink_signal_attract.connect(_player_blinked)

func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
	

func _physics_process(delta):
	if velocity!=Vector3(0,0,0):
		look_at(transform.origin + velocity, Vector3.UP)
	
func _on_vision_area_body_entered(body): #small sphere and cone detector check for physical objects 
	#print("moth has spotted: " + body.name)
	if body.name == "PlayerCharacter":
		print("player_seen")
		if randi_range(1,4)==1:
			$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")
		else:
			$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothStalk")

func _on_moth_stalk_switch_to_chase() -> void:
	$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothChase")


func _on_visible_on_screen_notifier_3d_screen_entered():
	on_screen = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	on_screen = false

func _player_blinked():
	if on_screen:
		$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothStalk")
		$StalkTimer.start()
		stalk_timer_active = true


func _on_stalk_timer_timeout():
	stalk_timer_active = false


func _on_kill_range_body_entered(body):
	if body.name == "PlayerCharacter":
		EventBus.jumpscare.emit()
		get_tree().call_group("Enemies", "queue_free")
		#body.jumpscare()
		#self.queue_free()
		#print("The part where it kills you")
		#get_tree().change_scene_to_file("res://retry_screen.tscn")

func GetLookatPoint():
	return $PlayerCameraAnchor


func _on_light_sensitive_body_entered(body):
	#print("(Looking for light) Moth found ", body.name)
	if body.name == "LightBody":#is_in_group("Lights"):
		if !(body.get_parent().current_state == 4):
			if !stalk_timer_active:
				print("moth has felt the light shining")
				$"State Machine".current_state.Transitioned.emit($"State Machine".current_state, "MothFollow")
				$"State Machine/MothFollow".light = body
			
