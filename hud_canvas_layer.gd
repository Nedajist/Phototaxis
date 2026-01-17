extends CanvasLayer
@onready var progress_bar: ProgressBar = %ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.sprint_changed.connect(sprint_changed)
	pass # Replace with function body.

func sprint_changed(sprint_meter):
	progress_bar.value = sprint_meter
