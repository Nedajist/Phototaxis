class_name LightPost
extends Node3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = %AudioStreamPlayer3D
#@onready var light_1: MeshInstance3D = %light_1
#@onready var light_2: MeshInstance3D = %light_2
#@onready var light_3: MeshInstance3D = %light_3

# there are four states that progress in the following order
# when the lights are reactivated, start from ON
enum LightState {
	ON,
	BLINK_LOW,
	BLINK_HIGH,
	BURNING_OUT,
	OFF
}
@export var light_parents:Array[Node3D]
@export var total_time_on:float = 13.0

# time in seconds at full strength
var duration_on: float = 4.0 * total_time_on / 13.0

# range in % luminosity that randomly increases and decreases
var flicker_max: float = 1.0
var flicker_min: float = 0.8

# time in seconds for the occasionally blinking state
var duration_blink_low: float = 6.0 * total_time_on / 13.0
var interval_blink_low: float = 1.0

# time in seconds for the commonly blinking state
var duration_blink_high: float = 3.0 * total_time_on / 13.0
var interval_blink_high: float = 0.5

# time in seconds for a light blink to fade out and turn back on
var blink_fade_out: float = 0.2
var blink_fade_in: float = 0.05

#time in seconds for a burnout
var burnout_time = 5

var selected_to_break: bool = false
var gas_low: bool = false
var gas_critical: bool = false
var gas_empty: bool = false

# State machine variables
var current_state: LightState = LightState.ON
var state_timer: float = 0.0
var blink_timer: float = 0.0
var is_blinking_off: bool = false
var lights: Array = []
var original_light_energy: Array = []
var original_light_color: Array = []

func _ready():
	duration_on = 4.0 * total_time_on / 13.0
	duration_blink_low = 6.0 * total_time_on / 13.0
	duration_blink_high = 3.0 * total_time_on / 13.0
	_cache_lights()
	_start_state(LightState.ON)

func _process(delta):
	match current_state:
		LightState.ON:
			_process_on_state(delta)
		LightState.BLINK_LOW:
			_process_blink_low_state(delta)
		LightState.BLINK_HIGH:
			_process_blink_high_state(delta)
		LightState.BURNING_OUT:
			_process_burnout_state(delta)
		LightState.OFF:
			pass  # Lights stay off

# Cache all light references and their original energy values
func _cache_lights():
	lights.clear()
	original_light_energy.clear()
	original_light_color.clear()
	
	#var light_parents = [
#		light_1,
#		light_2,
#		light_3
#	]
	
	for light_parent in light_parents:
		for child in light_parent.get_children():
			if child is Light3D:
				lights.append(child)
				original_light_energy.append(child.light_energy)
				original_light_color.append(child.light_color)

# Start a new state
func _start_state(new_state: LightState):
	current_state = new_state
	state_timer = 0.0
	blink_timer = 0.0
	is_blinking_off = false
	
	match current_state:
		LightState.ON:
			_set_lights_visible(true)
		LightState.BLINK_LOW:
			_set_lights_visible(true)
		LightState.BLINK_HIGH:
			_set_lights_visible(true)
		LightState.OFF:
			_set_lights_visible(false)
		LightState.BURNING_OUT:
			_set_lights_visible(true)

func _process_burnout_state(delta):
	state_timer += delta
	for light in lights:
		if light is Light3D:
			light.light_energy += 2 * delta
			light.light_color.b8 = min(light.light_color.b8 + 255 * delta, 255)
				
	if state_timer >= burnout_time:
		selected_to_break = false
		deactivate()

# Process ON state: flicker lights randomly
func _process_on_state(delta):
	state_timer += delta
	
	# Apply random flicker to each light
	for i in range(lights.size()):
		if lights[i] is Light3D:
			var flicker_amount = randf_range(flicker_min, flicker_max)
			lights[i].light_energy = ((original_light_energy[i] * flicker_amount) + original_light_energy[i]) / 2
	
	# Transition to BLINK_LOW after duration
	if selected_to_break:
		_start_state(LightState.BURNING_OUT)
	elif gas_low:
		_start_state(LightState.BLINK_LOW)

# Process BLINK_LOW state: occasional blinks
func _process_blink_low_state(delta):
	state_timer += delta
	blink_timer += delta
	
	_process_blinking(delta, interval_blink_low)
	
	# Transition to BLINK_HIGH based on gas state
	if gas_critical:
		_start_state(LightState.BLINK_HIGH)
	# Transition to on if the tank was refilled
	elif !gas_low:
		_start_state(LightState.ON)

# Process BLINK_HIGH state: frequent blinks
func _process_blink_high_state(delta):
	state_timer += delta
	blink_timer += delta
	
	_process_blinking(delta, interval_blink_high)
	
	# Transition to OFF after duration
	if gas_empty:
		deactivate()
	elif !gas_critical:
		_start_state(LightState.ON)

# Handle the blinking on/off cycle
func _process_blinking(_delta, blink_interval):
	if is_blinking_off:
		# Currently off, waiting to fade back in
		if blink_timer >= blink_fade_out:
			# Fade back in
			var fade_progress = (blink_timer - blink_fade_out) / blink_fade_in
			if fade_progress >= 1.0:
				# Finished fading in, start next blink cycle
				_set_lights_energy_multiplier(1.0)
				is_blinking_off = false
				blink_timer = 0.0
			else:
				# Fading in
				_set_lights_energy_multiplier(fade_progress)
	else:
		# Currently on, check if time to blink off
		if blink_timer >= blink_interval:
			# Start fading out
			is_blinking_off = true
			blink_timer = 0.0
		else:
			# Apply subtle flicker while on
			for i in range(lights.size()):
				if lights[i] is Light3D:
					var flicker_amount = randf_range(flicker_min, flicker_max)
					lights[i].light_energy = original_light_energy[i] * flicker_amount
	
	# Handle fade out transition
	if is_blinking_off and blink_timer < blink_fade_out:
		var fade_progress = 1.0 - (blink_timer / blink_fade_out)
		_set_lights_energy_multiplier(fade_progress)

# Set light energy as a multiplier of original values
func _set_lights_energy_multiplier(multiplier: float):
	for i in range(lights.size()):
		if lights[i] is Light3D:
			lights[i].light_energy = original_light_energy[i] * multiplier

# Set all lights visible or invisible
func _set_lights_visible(_visible: bool):
	for light in lights:
		if light is Light3D:
			light.visible = _visible
			if visible:
				light.light_energy = original_light_energy[lights.find(light)]
				light.light_color = original_light_color[lights.find(light)]
			else:
				light.light_energy = 0.0

# Public API: Manually deactivate lights (skip to OFF state)
func deactivate():
	EventBus.floodlight_deactivated.emit(self)
	_start_state(LightState.OFF)

# Public API: Reactivate lights (restart from ON state)
func activate():
	EventBus.floodlight_activated.emit(self)
	audio_stream_player_3d.play()
	_start_state(LightState.ON)
	
