extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://moth_testing_scene.tscn")
