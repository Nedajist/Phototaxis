# autoloaded
# class_name EventBus 
extends Node

signal sprint_changed

#Add signals to this dummy function to silence warnings
func silence_warnings() -> void:
	sprint_changed.emit()
