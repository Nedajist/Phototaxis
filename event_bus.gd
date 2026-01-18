# autoloaded
# class_name EventBus 
extends Node

signal jumpscare

signal sprint_changed
signal interaction_progress
signal interaction_complete
signal no_interactable_in_range
signal interactables_in_range


#Add signals to this dummy function to silence warnings
func silence_warnings() -> void:
	jumpscare.emit()
	
	sprint_changed.emit()
	interaction_progress.emit()
	interaction_complete.emit()
	no_interactable_in_range.emit()
	interactables_in_range.emit()
