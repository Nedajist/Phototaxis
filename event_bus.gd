# autoloaded
# class_name EventBus 
extends Node

signal jumpscare

signal mothster_attempt_pickup
signal gasoline_attempt_pickup
signal mothster_picked_up
signal gasoline_picked_up
signal mothster_used
signal gasoline_used
signal sprint_changed
signal interaction_progress
signal interaction_complete
signal no_interactable_in_range
signal interactables_in_range
signal generator_interacted
signal generator_filled_with_gas


#Add signals to this dummy function to silence warnings
func silence_warnings() -> void:
	jumpscare.emit()
	
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
