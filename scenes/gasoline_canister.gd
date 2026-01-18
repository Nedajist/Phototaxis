class_name GasolineCanister
extends StaticBody3D

func interact():
	EventBus.gasoline_attempt_pickup.emit(self)

func destroy():
	queue_free()
