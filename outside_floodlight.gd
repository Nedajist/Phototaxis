extends Node3D
@export var duration_on: float
var timer

func _ready():
	if(duration_on):
		timer = duration_on
		
func _process(delta):
	if(duration_on):
		if(timer <= 0):
			_deactivate_lights()
		else:
			timer -= delta
	
#deactivates the light sources
func _deactivate_lights():
	var lights = [] 
	lights.append($main_box/lightpost/lightpost_crossbar/light_1)
	lights.append($main_box/lightpost/lightpost_crossbar/light_2)
	lights.append($main_box/lightpost/lightpost_crossbar/light_3)
	
	for light in lights:
		for child in light.get_children():
			child.visible = false

#reactivates the light sources on this object
func _activate_lights():
	var lights = [] 
	lights.append($main_box/lightpost/lightpost_crossbar/light_1)
	lights.append($main_box/lightpost/lightpost_crossbar/light_2)
	lights.append($main_box/lightpost/lightpost_crossbar/light_3)
	
	for light in lights:
		for child in light.get_children():
			child.visible = true
