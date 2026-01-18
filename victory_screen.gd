extends CanvasLayer

@export var first_level: PackedScene

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry():
	var tree = get_tree()
	tree.change_scene_to_packed(first_level)
