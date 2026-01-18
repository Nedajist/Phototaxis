extends Timer


func _ready():
	start()

func _process(_delta):
	EventBus.update_time.emit(time_left)

func _on_timer_timeout():
	var tree = get_tree()
	tree.change_scene_to_file("res://victory_screen.tscn")
