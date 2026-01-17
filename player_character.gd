class_name PlayerCharacter
extends CharacterBody3D
@onready var camera_3d: Camera3D = %Camera3D

@export var mouse_sensitivity = 0.002
var camera_pitch: float = 0.0
var mouse_locked = true

const SPEED = 10.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent):
	# Handle mouse movement for looking around
	if event is InputEventMouseMotion:
		# Rotate the entire CharacterBody3D around the Y-axis (left/right)
		
		# Rotate the Camera3D around its local X-axis (up/down)
		camera_pitch += -event.relative.y * mouse_sensitivity
		# Clamp the camera pitch to prevent it from flipping upside down
		camera_pitch = clamp(camera_pitch, deg_to_rad(-90), deg_to_rad(90))
		
		
		if mouse_locked:
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera_3d.rotation.x = camera_pitch
		
	if Input.is_action_just_pressed("escape"):
		if not mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_locked = !mouse_locked

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# camera controls
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
