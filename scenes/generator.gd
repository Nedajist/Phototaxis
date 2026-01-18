class_name Generator
extends StaticBody3D

#how long a full tank can last in seconds
@export var tank_longevity: float
var gas_remaining

func _ready():
	gas_remaining = tank_longevity
	EventBus.generator_filled_with_gas.connect(_refilled)
	EventBus.generator_filled_with_gas.emit()

func _process(delta):
	if(gas_remaining > 0):
		gas_remaining -= delta
		if(gas_remaining <= 0):
			EventBus.gas_empty.emit()
		elif(gas_remaining <= tank_longevity*0.2):
			EventBus.gas_critical.emit()
		elif(gas_remaining <= tank_longevity*0.4):
			EventBus.gas_low.emit()

func interact():
	EventBus.generator_interacted.emit()

func _refilled():
	gas_remaining = tank_longevity
