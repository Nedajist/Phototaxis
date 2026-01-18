extends Node2D
@onready var retry_button: Button = %RetryButton
@onready var exit_button: Button = %ExitButton
const TITLE_SCREEN = preload("res://scenes/title_screen.tscn")
const LEVEL_FULL = preload("res://scenes/level_full.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	retry_button.pressed.connect(_on_retry_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_retry_button_pressed():
	get_tree().change_scene_to_packed(TITLE_SCREEN)
	
func _on_exit_button_pressed():
	get_tree().quit(0)
