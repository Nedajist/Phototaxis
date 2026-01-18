extends Control
const TITLE_SCREEN = "res://scenes/title_screen.tscn"

@onready var title_button: Button = %TitleButton

func _ready() -> void:
	title_button.pressed.connect(_on_title_button_pressed)
	
func _on_title_button_pressed():
	get_tree().change_scene_to_file(TITLE_SCREEN)
