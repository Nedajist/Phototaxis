extends CanvasLayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var radial_progress_bar: TextureProgressBar = %RadialProgressBar
@onready var interact_label: Label = %InteractLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.sprint_changed.connect(sprint_changed)
	EventBus.interaction_progress.connect(interaction_progress_changed)
	EventBus.interaction_complete.connect(interaction_complete)
	EventBus.no_interactable_in_range.connect(no_interactable_in_range)
	EventBus.interactables_in_range.connect(interactables_in_range)
	

func sprint_changed(sprint_meter) -> void:
	progress_bar.value = sprint_meter

func interaction_progress_changed(progress) -> void:
	radial_progress_bar.value = progress

func interaction_complete() -> void:
	radial_progress_bar.value = 0

func no_interactable_in_range() -> void:
	interact_label.visible = false
	pass
func interactables_in_range(interactables:Array) -> void:
	interact_label.visible = true
	interactables.pick_random() #silence warnings for stub 
	pass
