class_name Generator
extends StaticBody3D


func interact():
	EventBus.generator_interacted.emit()
