extends Timer


func _ready():
	start()

func _process(_delta):
	EventBus.update_time.emit(time_left)

func _on_timer_timeout():
	print("level survived!")
