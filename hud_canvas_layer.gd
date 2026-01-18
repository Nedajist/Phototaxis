extends CanvasLayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var gas_progress_bar: ProgressBar = %GasProgressBar
@onready var radial_progress_bar: TextureProgressBar = %RadialProgressBar
@onready var interact_label: Label = %InteractLabel
@onready var gasoline_texture_rect: TextureRect = %GasolineTextureRect
@onready var mothster_texture_rect: TextureRect = %MothsterTextureRect
@onready var mothster_label: Label = %MothsterLabel

# time in seconds to open / close
var blinking = false
var blink_progress = 0.0
var blink_signal_fired:bool = false
signal blink_signal
signal blink_signal_attract
var rng = RandomNumberGenerator.new()
# out of 300
# 100 to close, 100 to pause, 100 to open
@export var blink_close_time = 0.25 # seconds to close
@export var blink_open_time = 0.1 # seconds to open
@export var blink_pause_time = 0.05 # seconds to remain closed
@export var blink_interval = 3.0 # seconds between blinks
var time_since_last_blink = 0.0
@onready var blink_top_bottom_progress_bar: TextureProgressBar = %BlinkTopBottomProgressBar
@onready var blink_bottom_top_progress_bar: TextureProgressBar = %BlinkBottomTopProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.sprint_changed.connect(_sprint_changed)
	EventBus.interaction_progress.connect(_interaction_progress_changed)
	EventBus.interaction_complete.connect(_interaction_complete)
	EventBus.no_interactable_in_range.connect(_no_interactable_in_range)
	EventBus.interactables_in_range.connect(_interactables_in_range)
	EventBus.gasoline_picked_up.connect(gasoline_pickup)
	EventBus.gasoline_used.connect(gasoline_used)
	EventBus.mothster_picked_up.connect(mothster_pickup)
	EventBus.mothster_used.connect(mothster_used)
	EventBus.mothster_ended.connect(mothster_ended)
	EventBus.gas_changed.connect(_gas_changed)
	
	# Initialize progress bars to fully open (0%)
	blink_top_bottom_progress_bar.value = 0
	blink_bottom_top_progress_bar.value = 0

func _process(delta: float) -> void:
	# Test to trigger blink every 3 seconds
	#time_since_last_blink += delta
	if Input.is_action_just_pressed("spacebar") and not blinking:
		blink_signal_fired = false
		blink()
		time_since_last_blink = 0.0
	
	_handle_blink(delta)

func _gas_changed(gas_percentage) -> void:
	gas_progress_bar.value = gas_percentage * 100

func _sprint_changed(sprint_meter) -> void:
	progress_bar.value = sprint_meter

func _interaction_progress_changed(progress) -> void:
	radial_progress_bar.value = progress

func _interaction_complete() -> void:
	radial_progress_bar.value = 0

func _no_interactable_in_range() -> void:
	interact_label.visible = false
	pass
func _interactables_in_range(interactables:Array) -> void:
	interact_label.visible = true
	interactables.pick_random() #silence warnings for stub 
	pass
	
func blink() -> void:
	blinking = true
	blink_progress = 0.0

func _handle_blink(delta: float) -> void:
	if blinking:
		if blink_progress <= 200.0 and !blink_signal_fired:
			if rng.randi_range(1,5) < 2:
				blink_signal_attract.emit()
			blink_signal.emit()
			blink_signal_fired = true
		# Animate the blink
		if blink_progress < 100.0:
			# Closing phase (0 to 100)
			var close_speed = 100.0 / blink_close_time
			blink_progress += close_speed * delta
			blink_progress = min(blink_progress, 100.0)
		elif blink_progress < 200.0:
			# Pause phase (100 to 200) - stay closed
			var pause_speed = 100.0 / blink_pause_time
			blink_progress += pause_speed * delta
			blink_progress = min(blink_progress, 200.0)
		elif blink_progress < 300.0:
			# Opening phase (200 to 300)
			var open_speed = 100.0 / blink_open_time
			blink_progress += open_speed * delta
			blink_progress = min(blink_progress, 300.0)
		else:
			# Blink complete, reset
			blinking = false
			blink_progress = 0.0
		
		# Update progress bars based on current progress
		if blink_progress <= 100.0:
			# Closing: bars fill from 0 to 100
			blink_top_bottom_progress_bar.value = blink_progress
			blink_bottom_top_progress_bar.value = blink_progress
		elif blink_progress <= 200.0:
			# Paused: bars stay at 100 (fully closed)
			blink_top_bottom_progress_bar.value = 100.0
			blink_bottom_top_progress_bar.value = 100.0
		else:
			# Opening: bars empty from 100 to 0
			var opening_progress = 300.0 - blink_progress
			blink_top_bottom_progress_bar.value = opening_progress
			blink_bottom_top_progress_bar.value = opening_progress

func mothster_pickup():
	mothster_label.visible = true
	mothster_texture_rect.visible = true
func mothster_used():
	mothster_label.visible = false
	mothster_texture_rect.visible = false
	progress_bar.modulate = Color.GREEN
func mothster_ended():
	progress_bar.modulate = Color.WHITE
func gasoline_pickup():
	gasoline_texture_rect.visible = true
func gasoline_used():
	gasoline_texture_rect.visible = false
