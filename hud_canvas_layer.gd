extends CanvasLayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var radial_progress_bar: TextureProgressBar = %RadialProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.sprint_changed.connect(sprint_changed)
	EventBus.interaction_progress.connect(interaction_progress_changed)
	EventBus.interaction_complete.connect(interaction_complete)
	

func sprint_changed(sprint_meter) -> void:
	progress_bar.value = sprint_meter

func interaction_progress_changed(progress) -> void:
	radial_progress_bar.visible = true
	radial_progress_bar.value = progress

func interaction_complete() -> void:
	print("done!")
	radial_progress_bar.visible = false
