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
