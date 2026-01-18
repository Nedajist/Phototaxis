class_name MothsterEnergy
extends StaticBody3D

func interact():
	EventBus.mothster_attempt_pickup.emit(self)

func destroy():
	queue_free()
