extends StaticBody3D
@onready var switch: Switch = %Switch
@export var attached_electronics: Array[Node3D] 

func _ready():
	EventBus.light_burned_out.connect(_burnout_flip)
	

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

func _burnout_flip(target):
	if target in attached_electronics:
		if switch.active:
			switch.animate_switch_off()
			await switch.animation_player.animation_finished
