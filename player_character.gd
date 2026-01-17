class_name PlayerCharacter
extends CharacterBody3D
@onready var camera_3d: Camera3D = %Camera3D
@onready var flashlight: Node3D = %Flashlight
@onready var interaction_area_3d: Area3D = %InteractionArea3D

@export var mouse_sensitivity = 0.002
var camera_pitch: float = 0.0
var flashlight_pitch: float = 0.0
var mouse_locked = true
const sprint_max:float = 100.0
const sprint_min:float = 0.0
var sprint_meter: float = 100.0
var sprinting = false

const SPEED = 2.0
const SPRINT_SPEED = 5.0

@export var interaction_hold_time: float = 1.0  # Time in seconds to hold for interaction
var interaction_hold_timer: float = 0.0
var is_interacting: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	# Check for interactables in range and emit signals
	_check_interactables_in_range()
	
	# Handle interaction hold mechanic
	if Input.is_action_just_pressed("interact") and not is_interacting:
		interaction_hold_timer = 0.0
		is_interacting = true
	
	if Input.is_action_pressed("interact") and is_interacting:
		interaction_hold_timer += delta
		var progress = interaction_hold_timer / interaction_hold_time * 100
		EventBus.interaction_progress.emit(progress)
		
		if interaction_hold_timer >= interaction_hold_time:
			_stop_interacting()
			_complete_interaction()
			
	if Input.is_action_just_released("interact"):
		_stop_interacting()

func _stop_interacting() -> void:
	is_interacting = false
	EventBus.interaction_progress.emit(0.0)
	interaction_hold_timer = 0.0
	
func _input(event: InputEvent):
	# Handle mouse movement for looking around
	if event is InputEventMouseMotion:
		handle_mouse_movement(event)
		
	if Input.is_action_just_pressed("escape"):
		if not mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_locked = !mouse_locked

func _physics_process(delta: float) -> void:
	# Add the gravity.
	handle_player_movement(delta)

func handle_mouse_movement(event) -> void:
	# Rotate the entire CharacterBody3D around the Y-axis (left/right)
	
	# Rotate the Camera3D around its local X-axis (up/down)
	camera_pitch += -event.relative.y * mouse_sensitivity
	# Clamp the camera pitch to prevent it from flipping upside down
	camera_pitch = clamp(camera_pitch, deg_to_rad(-90), deg_to_rad(90))
	
	# Rotate the Flashlight around its local X-axis (up/down) with clamping
	flashlight_pitch += -event.relative.y * mouse_sensitivity
	flashlight_pitch = clamp(flashlight_pitch, deg_to_rad(-40), deg_to_rad(40))
	
	if mouse_locked:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotation.x = camera_pitch
		flashlight.rotation.x = flashlight_pitch

func handle_player_movement(delta) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("shift") and sprint_meter > 1:
		sprinting = true
		sprint_meter -= 1
		sprint_meter = max(sprint_min, sprint_meter)
	else:
		sprinting = false
		sprint_meter += .25
		sprint_meter = min(sprint_max, sprint_meter)
		
	EventBus.sprint_changed.emit(sprint_meter)
	
	var speed = SPEED
	if(sprinting): speed = SPRINT_SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _get_interactables() -> Array:
	# Returns array of all bodies in interaction area that have interact() method
	var interactables = []
	var overlapping_bodies = interaction_area_3d.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.has_method("interact"):
			interactables.append(body)
	
	return interactables

func _check_interactables_in_range() -> void:
	# Check if there are interactables in range and emit appropriate signal
	var interactables = _get_interactables()
	
	if interactables.size() > 0:
		EventBus.interactables_in_range.emit(interactables)
	else:
		EventBus.no_interactable_in_range.emit()

func _complete_interaction() -> void:
	# Get all interactables and call their interact() method
	var interactables = _get_interactables()
	
	for interactable in interactables:
		interactable.interact()
	
	EventBus.interaction_complete.emit()
