extends Node3D

#external node that can coordinate light shutdowns across all relevant nodes
enum Mode {
	Random,
	Top_Most
}

@export var behavior: Mode

#populate with all light sources in the scene you want to be toggled
@export var light_sources: Array[Node3D]

#how often to turn off a light
@export var frequency: float

var timer
var deactivated_lights:Array[Node3D]

func _ready():
	EventBus.generator_filled_with_gas.connect(_gasoline_refilled)
	EventBus.floodlight_activated.connect(_light_reactivate)
	EventBus.floodlight_deactivated.connect(_light_deactivate)
	
	EventBus.gas_low.connect(_gasoline_low)
	EventBus.gas_critical.connect(_gasoline_critical)
	EventBus.gas_empty.connect(_gasoline_empty)
	timer = frequency
	#for light:LightPost in light_sources:
		#light.total_time_on = frequency
	if(behavior == Mode.Random):
		randomize()

func _process(delta):
	timer -= delta
	if(timer <= 0 && light_sources.size() > 0):
		var target
		match behavior:
			Mode.Random:
				target = randi_range(0, light_sources.size() - 1)
				#print(target)
			Mode.Top_Most:
				target = 0
		light_sources[target].selected_to_break = false
		#deactivated_lights.append(light_sources[target])
		#light_sources.remove_at(target)
		timer = frequency

func _light_reactivate(target):
	if(!light_sources.has(target) and deactivated_lights.has(target)):
		light_sources.append(target)
		deactivated_lights.erase(target)
		
func _light_deactivate(target):
	if(light_sources.has(target) and !deactivated_lights.has(target)):
		light_sources.erase(target)
		deactivated_lights.append(target)

func _gasoline_refilled():
	
	#if any were still active, let them know
	for light in light_sources:
		light.gas_low = false
		light.gas_critical = false
		light.gas_empty = false
	
	#work from the back to prevent indexing errors
	while deactivated_lights.size() > 0:
		var target = deactivated_lights.back()
		
		target.gas_low = false
		target.gas_critical = false
		target.gas_empty = false
		
		if(target.has_method("activate")):
			target.activate() #activate leads to a pop from the back

func _gasoline_low():
	for light in light_sources:
		light.gas_low = true 
	for light in deactivated_lights:
		light.gas_low = true
	
func _gasoline_critical():
	for light in light_sources:
		light.gas_critical = true 
	for light in deactivated_lights:
		light.gas_critical = true

func _gasoline_empty():
	for light in light_sources:
		light.gas_empty = true
	for light in deactivated_lights:
		light.gas_empty = true
