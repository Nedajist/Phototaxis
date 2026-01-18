class_name InventoryComponent
extends Node3D

var has_mothster = false
var has_gasoline = false

func _ready() -> void:
	EventBus.gasoline_attempt_pickup.connect(gasoline_attempt_pickup)
	EventBus.mothster_attempt_pickup.connect(mothster_attempt_pickup)
	EventBus.generator_interacted.connect(generator_interacted)

func mothster_attempt_pickup(mothster:MothsterEnergy):
	if(!has_mothster):
		has_mothster = true
		EventBus.mothster_picked_up.emit()
		mothster.destroy()
	
func gasoline_attempt_pickup(gasoline:GasolineCanister):
	if(!has_gasoline):
		has_gasoline = true
		EventBus.gasoline_picked_up.emit()
		gasoline.destroy()
		
func generator_interacted():
	if(has_gasoline):
		EventBus.generator_filled_with_gas.emit()
		has_gasoline = false
		EventBus.gasoline_used.emit()
