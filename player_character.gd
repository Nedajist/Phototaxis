class_name PlayerCharacter
extends CharacterBody3D
@onready var camera_3d: Camera3D = %Camera3D
@onready var flashlight: Node3D = %Flashlight

@export var mouse_sensitivity = 0.002
var camera_pitch: float = 0.0
var mouse_locked = true
const sprint_max:float = 100.0
const sprint_min:float = 0.0
var sprint_meter: float = 100.0
var sprinting = false

const SPEED = 2.0
const SPRINT_SPEED = 5.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
	
	if mouse_locked:
		rotate_y(-event.relative.x * mouse_sensitivity)
		flashlight.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = camera_pitch

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
