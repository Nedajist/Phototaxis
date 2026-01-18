# autoloaded
# class_name EventBus 
extends Node

signal sprint_changed
signal interaction_progress
signal interaction_complete
signal no_interactable_in_range
signal interactables_in_range
signal generator_interacted
signal generator_filled_with_gas

signal floodlight_activated(Node3D)
signal floodlight_deactivated(Node3D)

signal gas_low
signal gas_critical
signal gas_empty

#Add signals to this dummy function to silence warnings
func silence_warnings() -> void:
	sprint_changed.emit()
	interaction_progress.emit()
	interaction_complete.emit()
	no_interactable_in_range.emit()
	interactables_in_range.emit()
	mothster_attempt_pickup.emit()
	gasoline_attempt_pickup.emit()
	mothster_picked_up.emit()
	gasoline_picked_up.emit()
	mothster_used.emit()
	gasoline_used.emit()
	generator_interacted.emit()
	generator_filled_with_gas.emit()
	
	floodlight_activated.emit(null)
	floodlight_deactivated.emit(null)
	
	gas_low.emit()
	gas_critical.emit()
	gas_empty.emit()
	
