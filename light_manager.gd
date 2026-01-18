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
		light_sources[target].selected_to_break = true
		deactivated_lights.append(light_sources[target])
		light_sources.remove_at(target)
		timer = frequency

func _light_reactivate(target):
	if(!light_sources.has(target) and deactivated_lights.has(target)):
		light_sources.append(target)
		deactivated_lights.erase(target)

func _gasoline_refilled():
	# TODO: Implement
	print("Gasoline Refilled!")
	pass
	
"""
there are two ways the lights can turn off

All lights are connected to a central generator, which will slowly run out of gas. When gas is running out, it will start blinking.
-> This can be fixed by filling the generator with gas (stub above)

Randomly, any given light has a chance to burn out. The lights will get brighter and brighter, then suddenly turn off.
-> This can be fixed by finding the breaker switches and fixing the correct light. Each light has a one-to-one or many-to-one (multiple lights per breaker) relationship with each breaker
"""
