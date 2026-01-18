extends CanvasLayer

@export var first_level: PackedScene
@export var title_screen: PackedScene 

var tree
func _ready():
	tree = get_tree()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry():
	tree.change_scene_to_packed(first_level)

func _on_title_screen() -> void:
	tree.change_scene_to_packed(title_screen)
