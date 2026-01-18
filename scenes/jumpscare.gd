extends Control
@onready var blackout_animation_player = %BlackoutAnimationPlayer
@onready var moth_container_animation_player = %MothContainerAnimationPlayer

func _ready():
	EventBus.jumpscare.connect(jumpscare)

func jumpscare():
	blackout_animation_player.play("fade_out_in")
	await get_tree().create_timer(3.0).timeout
	$JumpscareSound.play()
	moth_container_animation_player.play("jumpscare")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://retry_screen.tscn")
	
