# autoloaded
# class_name EventBus 
extends Node

signal sprint_changed
signal interaction_progress
signal interaction_complete

#Add signals to this dummy function to silence warnings
func silence_warnings() -> void:
	sprint_changed.emit()
	interaction_progress.emit()
	interaction_complete.emit()
