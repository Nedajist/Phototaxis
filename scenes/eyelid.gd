extends Control
@onready var eyelid_top: TextureProgressBar = %EyelidTop
@onready var eyelid_bottom: TextureProgressBar = %EyelidBottom

@export var initial_pause:float = 1.5
@export var duration_close:float = 0.5
@export var duration_stay_closed:float = 0.3
@export var duration_open:float = 0.15
@export var duartion_stay_open:float = 3.0

var blink_tween: Tween

func _ready() -> void:
	# Start blinking automatically when the scene loads
	start_blinking()

func start_blinking() -> void:
	# Wait for initial pause before starting the blink cycle
	await get_tree().create_timer(initial_pause).timeout
	_blink_cycle()

func _blink_cycle() -> void:
	# Kill any existing tween to prevent conflicts
	if blink_tween:
		blink_tween.kill()
	
	blink_tween = create_tween()
	blink_tween.set_loops() # Loop infinitely
	
	# Close eyelids (0 to 51)
	blink_tween.tween_property(eyelid_top, "value", 51, duration_close)
	blink_tween.parallel().tween_property(eyelid_bottom, "value", 51, duration_close)
	
	# Stay closed
	blink_tween.tween_interval(duration_stay_closed)
	
	# Open eyelids (51 to 0)
	blink_tween.tween_property(eyelid_top, "value", 0, duration_open)
	blink_tween.parallel().tween_property(eyelid_bottom, "value", 0, duration_open)
	
	# Stay open
	blink_tween.tween_interval(duartion_stay_open)

func stop_blinking() -> void:
	# Stop the blinking animation
	if blink_tween:
		blink_tween.kill()
		blink_tween = null
