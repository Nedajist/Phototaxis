extends Node

@export var audio_manager: AudioStreamPlayer
var ambient_1=preload("res://musics/game_ambience1.mp3")
var ambient_2=preload("res://musics/game_ambience2.mp3")
var chase_1=preload("res://musics/game_chase1.wav")
var chase_2=preload("res://musics/game_chase2.mp3")

var number_of_aggressive_moths=0
var previous_number_of_aggressive_moths=0

func _ready():
	ambient_begin()


func _physics_process(delta: float) -> void:
	if number_of_aggressive_moths==0 and previous_number_of_aggressive_moths>0:
		ambient_begin()
	
	elif number_of_aggressive_moths>0 and previous_number_of_aggressive_moths==0:
		chase_begin()
	
	previous_number_of_aggressive_moths=number_of_aggressive_moths
	

func ambient_begin():
	await get_tree().create_timer(randf_range(1,4)).timeout
	if number_of_aggressive_moths==0:
		if randi_range(1,2)==1:
			audio_manager.stream=ambient_1
		else:
			audio_manager.stream=ambient_2
		audio_manager.play()


func chase_begin():
	if randi_range(1,2)==1:
		audio_manager.stream=chase_1
	else:
		audio_manager.stream=chase_2
	
	audio_manager.play()
