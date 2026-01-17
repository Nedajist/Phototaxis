extends StaticBody3D
@onready var switch: Switch = %Switch
@export var attached_electronics: Array[Node3D] 

func interact():
	if switch.active:
		switch.animate_switch_off()
		await switch.animation_player.animation_finished
		for electronic in attached_electronics:
			if electronic.has_method("deactivate"):
				electronic.deactivate()
	else:
		switch.animate_switch_on()
		await switch.animation_player.animation_finished
		for electronic in attached_electronics:
			if electronic.has_method("activate"):
				electronic.activate()
