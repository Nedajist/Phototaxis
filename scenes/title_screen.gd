extends Control

#play button "res://scenes/level_full.tscn"
#credits button
const LEVEL_FULL = preload("res://scenes/level_full.tscn")
const CREDITS = preload("res://scenes/credits.tscn")

@onready var play_button: Button = %PlayButton
@onready var credits_button: Button = %CreditsButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	play_button.pressed.connect(_on_ready_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
func _on_ready_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_FULL)
	pass
func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)
	
func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
